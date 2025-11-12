require 'spec_helper'

describe Neighborly::Api::V1::PressAssetsController do
  routes { Neighborly::Api::Engine.routes }
  let(:parsed_response) { JSON.parse(response.body) }

  describe '#index', authorized: true do
    let!(:press_asset) { FactoryGirl.create(:press_asset) }
    let(:do_request)   { get :index, format: :json }

    it_behaves_like 'paginating results'

    it 'responds with 200' do
      do_request
      expect(response.status).to eql(200)
    end

    it 'has a top level element called press_assets' do
      do_request
      expect(parsed_response.fetch('press_assets')).to be_a(Array)
    end

    it 'responds with data of press_assets' do
      do_request
      expect(
        parsed_response.fetch('press_assets').first
      ).to have_key('id')
    end
  end

  describe '#create', authorized: true, admin: true do
    let(:params)     { FactoryGirl.build(:press_asset).attributes.merge(image: Rack::Test::UploadedFile.new("#{Neighborly::Api::Engine.root}/spec/fixtures/image.png"))}
    let(:do_request) { post :create, press_asset: params, format: :json }

    context 'on success' do
      it 'returns a created http status' do
        do_request
        expect(response.status).to eq(201)
      end

      it 'returns a json' do
        do_request

        expect(parsed_response.count).to eq(1)
        expect(parsed_response['press_asset']['title']).to eq('Lorem')
        expect(parsed_response['press_asset']['url']).to eq('http://lorem.com')
      end
    end

    context 'on failure' do
      let(:do_request) { post :create, press_asset: { }, format: :json }

      it 'returns a unprocessable entity http status' do
        do_request
        expect(response.status).to eq(422)
      end

      it 'returns a json with errors' do
        do_request

        expect(parsed_response.count).to eq(1)
        expect(parsed_response['errors']['title']).not_to be_empty
      end
    end
  end

  describe '#update', authorized: true, admin: true do
    let!(:press_asset) { FactoryGirl.create(:press_asset) }

    let(:do_request) do
      put :update,
          id: press_asset,
          press_asset: { title: 'foobar' }, format: :json
    end

    context 'on success' do
      it 'returns a no content http status' do
        do_request
        expect(response.status).to eq(204)
      end
    end

    context 'on failure' do
      let(:do_request) { put :update, id: press_asset, press_asset: { title: '' }, format: :json }

      it 'returns a unprocessable entity http status' do
        do_request
        expect(response.status).to eq(422)
      end

      it 'returns a json with errors' do
        do_request

        expect(parsed_response.count).to eq(1)
        expect(parsed_response['errors']['title']).not_to be_empty
      end
    end
  end

  describe '#show', authorized: true do
    let!(:press_asset)       { FactoryGirl.create(:press_asset) }
    let(:do_request) { get :show, id: press_asset, format: :json }

    it 'returns a success http status' do
      do_request
      expect(response.status).to eq(200)
    end

    it 'returns a json' do
      do_request

      expect(parsed_response.count).to eq(1)
      expect(parsed_response['press_asset']['title']).to eq(press_asset.title)
      expect(parsed_response['press_asset']['url']).to eq(press_asset.url)
    end
  end

  describe '#destroy', authorized: true, admin: true do
    let!(:press_asset)       { FactoryGirl.create(:press_asset) }
    let(:do_request) { delete :destroy, id: press_asset, format: :json }

    it 'returns a success http status' do
      do_request
      expect(response.status).to eq(204)
      expect { press_asset.reload }.to raise_error
    end
  end
end

