require 'spec_helper'

describe Neighborly::Api::V1::ContributionsController do
  routes { Neighborly::Api::Engine.routes }
  let!(:contribution) { FactoryGirl.create(:contribution) }

  let(:contributions_returned) do
    parsed_response.fetch('contributions').map { |t| t['id'] }
  end

  let(:parsed_response) { JSON.parse(response.body) }

  describe '#index', authorized: true, admin: true do
    let(:do_request) { get :index, format: :json }

    it_behaves_like 'paginating results'

    it 'filters by query' do
      contribution = FactoryGirl.create(:contribution, payment_method: 'balanced')
      FactoryGirl.create(:contribution, payment_method: 'paypal')
      get :index, format: :json, query: 'balanced'
      expect(contributions_returned).to eql([contribution.id])
    end

    describe 'filtering by between_values' do
      before do
        @contribution_30 = FactoryGirl.create(:contribution, value: 30)
        @contribution_35 = FactoryGirl.create(:contribution, value: 35)
        FactoryGirl.create(:contribution, value: 40)
      end

      it 'returns just those contributions in the given range' do
        get :index, format: :json,
          between_values: {
            initial: 30,
            final:   35
          }
        expect(contributions_returned).to eql([@contribution_35.id, @contribution_30.id])
      end
    end

    describe 'filter by state' do
      let!(:pending_contribution) do
        FactoryGirl.create(:contribution, state: :pending)
      end

      Contribution.state_names.each do |state|
        it "filters by state #{state}" do
          contribution = FactoryGirl.create(:contribution, state: state)
          expected_ids = if state.eql?(:pending)
            [contribution.id, pending_contribution.id]
          else
            [contribution.id]
          end

          get :index, format: :json, state => '1'
          expect(contributions_returned).to include(*expected_ids)
        end
      end
    end

    describe 'filter by project id' do
      let(:first_project)  { FactoryGirl.create(:project, state: 'online') }
      let(:second_project) { FactoryGirl.create(:project, state: 'online') }

      before do
        @contribution = FactoryGirl.create(:contribution, value: 10, project: first_project)
        FactoryGirl.create(:contribution, value: 10, project: second_project)
      end

      it 'returns just those contributions in the given project id' do
        get :index, project_id: first_project.id, format: :json
        expect(contributions_returned).to eql([@contribution.id])
      end
    end
  end

  describe '#show', authorized: true, admin: true do
    let(:do_request) { get :show, id: contribution.id, format: :json }

    it 'responds with 200' do
      do_request
      expect(response.status).to eql(200)
    end

    it 'has a top level element called contribution' do
      do_request
      expect(parsed_response.fetch('contribution')).to be_a(Hash)
    end

    it 'responds with data of the given contribution' do
      do_request
      expect(
        parsed_response.fetch('contribution')
      ).to have_key('id')
    end
  end

  describe '#update', authorized: true, admin: true do
    let(:do_request) do
      put :update,
          id: contribution.id,
          contribution: { value: 15 },
          format: :json
    end

    it 'updates the record' do
      expect(::Contribution).to receive(:update)
        .with(contribution.id.to_s, { 'value' => 15 })

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
            id: contribution.id,
            contribution: { value: nil },
            format: :json
      end

      it 'returns a unprocessable entity http status' do
        do_request
        expect(response.status).to eq(422)
      end

      it 'returns a json with errors' do
        do_request

        expect(parsed_response.count).to eq(1)
        expect(parsed_response['errors']['value']).not_to be_empty
      end
    end
  end

  describe 'destroy', authorized: true, admin: true do
    let(:do_request) { delete :destroy, id: contribution.id, format: :json }

    it 'returns a success http status' do
      do_request
      expect(response.status).to eq(204)
      expect(contribution.reload.deleted?).to be_truthy
    end
  end

  [:confirm, :pendent, :refund, :hide, :cancel].each do |name|
    describe "#{name}", authorized: true, admin: true do
      let(:user)         { FactoryGirl.create(:user, admin: true) }
      let(:contribution) do
        state = (name == :refund) ? 'confirmed' : 'deleted'
        FactoryGirl.create(:contribution, state: state)
      end
      let(:do_request)   { put name, id: contribution.id, format: :json }

      it 'returns a success http status' do
        do_request
        expect(response.status).to eq(204)
      end

      it 'authorizes the resource' do
        expect(controller).to receive(:authorize).with(contribution)
        do_request
      end

      it 'calls the state machine helper to change the state' do
        expect_any_instance_of(Contribution).to receive("#{name}!")
        do_request
      end
    end
  end
end
