require 'spec_helper'

describe Neighborly::Api::V1::TagsController do
  routes { Neighborly::Api::Engine.routes }
  let(:parsed_response) { JSON.parse(response.body) }

  describe '#index', authorized: true do
    let!(:tag)       { FactoryGirl.create(:tag) }
    let(:do_request) { get :index, format: :json }

    it_behaves_like 'paginating results'

    it 'responds with 200' do
      do_request
      expect(response.status).to eql(200)
    end

    it 'has a top level element called tags' do
      do_request
      expect(parsed_response.fetch('tags')).to be_a(Array)
    end

    it 'responds with data of tags' do
      do_request
      expect(
        parsed_response.fetch('tags').first
      ).to have_key('id')
    end

    describe 'filter by popular' do
      let!(:popular) { FactoryGirl.create(:tag_popular) }

      it 'accepts truthy popular parameter' do
        get :index, format: :json, popular: '1'
        response_ids = parsed_response.fetch('tags').map { |t| t['id'] }
        expect(response_ids).to eql([popular.id])
      end

      it 'skip any filtering for popular when receiving falsy value' do
        get :index, format: :json, popular: '0'
        response_ids = parsed_response.fetch('tags').map { |t| t['id'] }
        expect(response_ids).to eql(Tag.pluck(:id))
      end
    end
  end

  describe '#create', authorized: true, admin: true do
    let(:do_request) { post :create, tag: { name: 'foobar', visible: true }, format: :json }

    context 'on success' do
      it 'returns a created http status' do
        do_request
        expect(response.status).to eq(201)
      end

      it 'returns a json' do
        do_request

        expect(parsed_response.count).to eq(1)
        expect(parsed_response['tag']['name']).to eq('foobar')
        expect(parsed_response['tag']['visible']).to eq(true)
      end
    end

    context 'on failure' do
      let(:do_request) { post :create, tag: { }, format: :json }

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

  describe '#update', authorized: true, admin: true do
    let!(:tag) { FactoryGirl.create(:tag) }

    let(:do_request) do
      put :update,
          id: tag,
          tag: { name: 'foobar', visible: true }, format: :json
    end

    context 'on success' do
      it 'returns a no content http status' do
        do_request
        expect(response.status).to eq(204)
      end
    end

    context 'on failure' do
      let(:do_request) { put :update, id: tag, tag: { name: '' }, format: :json }

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

  describe '#show', authorized: true do
    let!(:tag)       { FactoryGirl.create(:tag) }
    let(:do_request) { get :show, id: tag, format: :json }

    it 'returns a success http status' do
      do_request
      expect(response.status).to eq(200)
    end

    it 'returns a json' do
      do_request

      expect(parsed_response.count).to eq(1)
      expect(parsed_response['tag']['name']).to eq(tag.name)
      expect(parsed_response['tag']['visible']).to eq(tag.visible)
    end
  end

  describe '#destroy', authorized: true, admin: true do
    let!(:tag)       { FactoryGirl.create(:tag) }
    let(:do_request) { delete :destroy, id: tag, format: :json }

    it 'returns a success http status' do
      do_request
      expect(response.status).to eq(204)
      expect { tag.reload }.to raise_error
    end
  end
end
