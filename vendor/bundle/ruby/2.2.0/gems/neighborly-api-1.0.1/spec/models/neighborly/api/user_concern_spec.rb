require 'spec_helper'

describe User do
  describe 'get_access_token' do
    subject { FactoryGirl.create(:user) }

    context 'when the user does not have an access token' do
      it 'creates an access token and returns its code' do
        expect {
          subject.get_access_token
        }.to change(subject.access_tokens.reload, :count).by(1)
      end

      it 'returns the last' do
        expect(subject.get_access_token).to eql(subject.access_tokens.last.code)
      end
    end

    context 'when the user already has one access token' do
      before { subject.access_tokens.create }

      it 'skips creation of a new' do
        expect {
          subject.get_access_token
        }.to_not change(subject.access_tokens.reload, :count)
      end

      it 'returns the last' do
        expect(subject.get_access_token).to eql(subject.access_tokens.last.code)
      end
    end
  end
end
