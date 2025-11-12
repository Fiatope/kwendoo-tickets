require 'spec_helper'

describe Neighborly::Api::V1::SessionsController do
  routes                { Neighborly::Api::Engine.routes }
  let!(:user)           { FactoryGirl.create(:user) }
  let(:parsed_response) { JSON.parse(response.body) }

  describe '#create' do
    it 'responds with 401 when requested with invalid email/password combination' do
      post :create, email: user.email, password: 'wrong-password'
      expect(response.status).to eql(401)
    end

    it 'responds with 401 when requested with invalid email' do
      post :create, email: 'wrong-email', password: 'wrong-password'
      expect(response.status).to eql(401)
    end

    it 'responds with 400 when requested with no email' do
      post :create, password: 'right-password'
      expect(response.status).to eql(400)
    end

    it 'responds with 400 when requested with no password' do
      post :create, email: user.email
      expect(response.status).to eql(400)
    end

    it 'responds with 201 when requested with valid email and password combination' do
      post :create, email: user.email, password: 'right-password'
      expect(response.status).to eql(201)
    end

    it 'returns session data when requested with valid email and password combination' do
      post :create, email: user.email, password: 'right-password'
      expect(parsed_response['access_token']).to eql(user.get_access_token)
      expect(parsed_response['user_id']).to      eql(user.id)
    end
  end

  describe '#destroy', authorized: true do
    let(:do_request) { delete :destroy }

    context 'when access_token is provided' do
      context 'and is valid' do
        before do
          request.env['HTTP_AUTHORIZATION'] = "Token token=#{valid_access_token.code}"
        end
        let(:valid_access_token) { FactoryGirl.create(:access_token, user: user) }

        it 'responds with 200' do
          expect(response.status).to eql(200)
        end

        it 'expires given access_token' do
          delete :destroy
          expect(valid_access_token.reload).to be_expired
        end

        it 'renders empty json' do
          delete :destroy
          expect(parsed_response).to be_empty
        end
      end
    end
  end
end
