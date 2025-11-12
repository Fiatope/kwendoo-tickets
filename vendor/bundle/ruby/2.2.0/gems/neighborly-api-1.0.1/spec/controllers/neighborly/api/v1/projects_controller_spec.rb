require 'spec_helper'

describe Neighborly::Api::V1::ProjectsController do
  include ActiveSupport::Testing::TimeHelpers
  routes { Neighborly::Api::Engine.routes }
  let(:projects_returned) do
    parsed_response.fetch('projects').map { |t| t['id'] }
  end
  let(:parsed_response) { JSON.parse(response.body) }

  describe '#index', authorized: true do
    let!(:project)   { FactoryGirl.create(:project) }
    let(:do_request) { get :index, format: :json }

    it_behaves_like 'paginating results'

    describe 'manageable' do
      before do
        @draft_project = FactoryGirl.create(:project, state: 'draft', user: user)
        @online_project = FactoryGirl.create(:project, state: 'online')
      end

      context 'when filtering by manageable projects' do
        let(:do_request) { get :index, format: :json, manageable: true }

        context 'when user is not an admin' do
          let(:user) { FactoryGirl.create(:user, admin: false) }

          it 'returns only mangeable projects' do
            do_request
            expect(projects_returned).to include(@draft_project.id)
          end
        end

        context 'when user is an admin' do
          let(:user) { FactoryGirl.create(:user, admin: true) }

          it 'returns all projects' do
            do_request
            expect(projects_returned).to include(@draft_project.id, @online_project.id)
          end
        end
      end

      context 'when not filtering by manageable projects' do
        let(:do_request) { get :index, format: :json, manageable: false }

        context 'when user is not an admin' do
          let(:user) { FactoryGirl.create(:user, admin: false) }

          it 'returns only public projects' do
            do_request
            expect(projects_returned).to include(@online_project.id)
            expect(projects_returned).not_to include(@draft_project.id)
          end
        end

        context 'when user is an admin' do
          let(:user) { FactoryGirl.create(:user, admin: true) }

          it 'returns only public projects' do
            do_request
            expect(projects_returned).to include(@online_project.id)
            expect(projects_returned).not_to include(@draft_project.id)
          end
        end
      end
    end

    describe 'ordering' do
      let!(:project_1) { FactoryGirl.create(:project, name: 'abc') }
      let!(:project_2) { FactoryGirl.create(:project, name: 'xyz') }

      it 'order by given attribute' do
        get :index, format: :json, order_by: 'name desc'
        expected_projects = [
          project.id,
          project_2.id,
          project_1.id
        ]
        expect(projects_returned).to eql(expected_projects)
      end
    end

    it 'filters by query' do
      FactoryGirl.create(:project, name: 'Ordinary project')
      project = FactoryGirl.create(:project, name: 'Wonderful project')
      get :index, format: :json, query: 'wonderful'
      expect(projects_returned).to eql([project.id])
    end

    describe 'filter by state' do
      let!(:draft_project) do
        FactoryGirl.create(:project, state: :draft, user: user)
      end

      Project.state_names.each do |state|
        it "filters by state #{state}" do
          project      = FactoryGirl.create(:project, state: state, user: user)
          expected_ids = if state.eql?(:draft)
            [project.id, draft_project.id]
          else
            [project.id]
          end

          get :index, format: :json, state => '1', manageable: true
          expect(projects_returned).to include(*expected_ids)
        end
      end
    end

    describe 'filtering by created_at' do
      before do
        travel_to(10.days.ago) do
          FactoryGirl.create(:project)
        end
      end

      it 'returns just those projects in the given range' do
        project = travel_to(3.days.ago) do
          FactoryGirl.create(:project)
        end
        get :index, format: :json,
          between_created_at: {
            starts_at: 6.days.ago.to_date.to_s,
            ends_at:   Time.now.to_date.to_s
          }
        expect(projects_returned).to eql([project.id])
      end
    end

    describe 'filtering by expires_at' do
      before do
        travel_to(10.days.ago) do
          FactoryGirl.create(:project, online_date: Date.current, online_days: 1)
        end
      end

      it 'returns just those projects in the given range' do
        project = travel_to(3.days.ago) do
          FactoryGirl.create(:project, online_date: Date.current, online_days: 1)
        end
        get :index, format: :json,
          between_expires_at: {
            starts_at: 6.days.ago.to_date.to_s,
            ends_at:   Time.now.to_date.to_s
          }
        expect(projects_returned).to eql([project.id])
      end
    end

    describe 'filtering by online_date' do
      before do
        FactoryGirl.create(:project, online_date: 10.days.from_now)
      end

      it 'returns just those projects in the given range' do
        project = FactoryGirl.create(:project, online_date: 3.days.from_now)
        get :index, format: :json,
          between_online_date: {
            starts_at: Time.now.to_date.to_s,
            ends_at:   6.days.from_now.to_date.to_s
          }
        expect(projects_returned).to eql([project.id])
      end
    end

    it 'checks permissions' do
      project = FactoryGirl.create(:project, state: :draft)
      do_request
      expect(projects_returned).not_to include(project.id)
    end
  end

  describe '#show', authorized: true do
    let(:project)    { FactoryGirl.create(:project, user: user) }
    let(:do_request) { get :show, id: project.id, format: :json }

    context 'when user has access to the project' do
      it 'responds with 200' do
        do_request
        expect(response.status).to eql(200)
      end

      it 'has a top level element called project' do
        do_request
        expect(parsed_response.fetch('project')).to be_a(Hash)
      end

      it 'responds with data of the given project' do
        do_request
        expect(
          parsed_response.fetch('project')
        ).to have_key('id')
      end
    end

    context 'when user does not have access to the project' do
      let(:project) { FactoryGirl.create(:project, state: 'draft') }

      it 'returns a forbidden http status' do
        do_request
        expect(response.status).to eq(403)
      end
    end
  end

  describe '#update', authorized: true do
    let(:project) { FactoryGirl.create(:project, user: user) }

    let(:do_request) do
      put :update,
          id: project.id,
          project: { name: 'Foo Bar Updated' },
          format: :json
    end

    context 'when user has access to the project' do
      it 'updates the record' do
        expect(Project).to receive(:update)
          .with(project.id.to_s, { "name" => 'Foo Bar Updated' })

        do_request
      end

      context 'on success' do
        it 'returns a no content http status' do
          do_request
          expect(response.status).to eq(204)
        end
      end

      context 'on failure' do
        let(:do_request) do
          put :update,
              id: project.id,
              project: { name: '' },
              format: :json
        end

        it 'returns a unprocessable entity http status' do
          do_request
          expect(response.status).to eq(422)
        end

        it 'returns a json with errors' do
          do_request

          expect(parsed_response.count).to eq(1)
          expect(parsed_response['errors']['name']).not_to be_empty
        end
      end
    end

    context 'when user does not have access to the project' do
      let(:project) { FactoryGirl.create(:project) }

      it 'does not update the record' do
        expect(Project).not_to receive(:update)
        do_request
      end

      it 'returns a forbidden http status' do
        do_request
        expect(response.status).to eq(403)
        expect(project.reload.deleted?).to be_falsy
      end
    end
  end

  describe 'destroy', authorized: true do
    let(:user)       { FactoryGirl.create(:user, admin: true) }
    let(:project)    { FactoryGirl.create(:project, user: user, state: :draft) }
    let(:do_request) { delete :destroy, id: project.id, format: :json }

    context 'when it can be pushed to trash' do
      it 'returns a success http status' do
        do_request
        expect(response.status).to eq(204)
        expect(project.reload.deleted?).to be_truthy
      end
    end

    context 'when it cannot be pushed to trash' do
      let(:project) { FactoryGirl.create(:project, user: user, state: :online) }

      it 'returns a forbidden http status' do
        do_request
        expect(response.status).to eq(403)
        expect(project.reload.deleted?).to be_falsy
      end
    end
  end

  [:approve, :launch, :reject, :push_to_draft].each do |name|
    describe "#{name}", authorized: true do
      let(:user)       { FactoryGirl.create(:user, admin: true) }
      let(:project)    { FactoryGirl.create(:project, state: :draft) }
      let(:do_request) { put name, id: project.id, format: :json }

      it 'returns a success http status' do
        do_request
        expect(response.status).to eq(204)
      end

      it 'authorizes the resource' do
        expect(controller).to receive(:authorize).with(project)
        do_request
      end

      it 'calls the state machine helper to change the state' do
        expect_any_instance_of(Project).to receive("#{name}!")
        do_request
      end
    end
  end
end
