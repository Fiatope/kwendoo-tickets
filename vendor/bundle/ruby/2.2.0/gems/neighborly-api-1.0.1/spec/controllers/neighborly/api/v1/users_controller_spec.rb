require 'spec_helper'

describe Neighborly::Api::V1::UsersController do
  routes                { Neighborly::Api::Engine.routes }
  let(:parsed_response) { JSON.parse(response.body) }
  let(:users_returned) do
    parsed_response.fetch('users').map { |t| t['id'] }
  end

  describe '#index', authorized: true, admin: true do
    let(:do_request) { get :index, format: :json }

    it_behaves_like 'paginating results'

    it 'filters by query' do
      FactoryGirl.create(:user, name: 'Ordinary user')
      _user = FactoryGirl.create(:user, name: 'Wonderful user')
      get :index, format: :json, query: 'wonderful'
      expect(users_returned).to eql([_user.id])
    end
  end

  describe '#show', authorized: true do
    let(:do_request) { get :show, id: user.id, format: :json }

    it 'responds with 200' do
      do_request
      expect(response.status).to eql(200)
    end

    it 'has a top level element called user' do
      do_request
      expect(parsed_response.fetch('user')).to be_a(Hash)
    end

    it 'responds with data of the given user' do
      do_request
      expect(
        parsed_response.fetch('user')
      ).to have_key('id')
    end
  end
end
