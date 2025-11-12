require 'spec_helper'

describe Neighborly::Api::V1::Channels::MembersController do
  routes                { Neighborly::Api::Engine.routes }
  let(:parsed_response) { JSON.parse(response.body) }
  let!(:channel)        { FactoryGirl.create(:channel) }
  let!(:member)         { FactoryGirl.create(:channel_member, channel: channel) }

  let(:records_returned) do
    parsed_response.fetch('users').map { |t| t['id'] }
  end

  describe '#index', authorized: true, admin: true do
    let(:do_request) { get :index, channel_id: channel.id, format: :json }

    it 'returns the members list' do
      do_request
      expect(records_returned.count).to eq 1
    end
  end

  describe '#create', authorized: true, admin: true do
    let(:new_user) { FactoryGirl.create(:user) }

    let(:do_request) do
      post :create,
        channel_id: channel.id,
        channel_member: { user_id: new_user.id },
        format: :json
    end

    it 'creates the record' do
      expect{ do_request }.to change{ channel.channel_members.count }.from(1).to(2)
    end

    context 'on success' do
      it 'returns a success http status' do
        do_request
        expect(response.status).to eq(201)
      end

      it 'returns the user' do
        do_request
        expect(parsed_response.fetch('user').fetch('id')).to eq new_user.id
      end
    end

    context 'on failure' do
      let(:do_request) do
      post :create,
        channel_id: channel.id,
        channel_member: { user_id: nil },
        format: :json
      end

      it 'returns a unprocessable entity http status' do
        do_request
        expect(response.status).to eq(422)
      end

      it 'returns a json with errors' do
        do_request

        expect(parsed_response.count).to eq(1)
        expect(parsed_response['errors']['user_id']).not_to be_empty
      end
    end
  end

  describe 'destroy', authorized: true, admin: true do
    let(:do_request) do
      delete :destroy, id: member.user.id, channel_id: channel.id, format: :json
    end

    it 'returns a success http status' do
      do_request
      expect(response.status).to eq(204)
      expect{ member.reload }.to raise_error
    end
  end
end

