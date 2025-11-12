require 'spec_helper'

describe Neighborly::Api::V1::RewardsController do
  routes                { Neighborly::Api::Engine.routes }
  let(:parsed_response) { JSON.parse(response.body) }
  let!(:reward)         { FactoryGirl.create(:reward) }

  describe '#show', authorized: true do
    let(:do_request) { get :show, id: reward.id, format: :json }

    it 'responds with 200' do
      do_request
      expect(response.status).to eql(200)
    end

    it 'has a top level element called reward' do
      do_request
      expect(parsed_response.fetch('reward')).to be_a(Hash)
    end

    it 'responds with data of the given reward' do
      do_request
      expect(
        parsed_response.fetch('reward')
      ).to have_key('id')
    end
  end
end
