require 'spec_helper'

describe Neighborly::Api::ApiConstraint do
  let(:request) { double :request }

  describe '#matches?' do
    let(:revision) { 1 }

    def header_for_revision(revision)
      "revision=#{revision}"
    end

    context 'when default is false' do
      subject(:constraint) { described_class.new(revision: revision) }


      it 'matches requests including the versioned vendor mime type' do
        headers = { accept: header_for_revision(revision) }
        allow(request).to receive(:headers).and_return(headers)

        expect(constraint.matches?(request)).to eq true
      end

      it 'does not match requests for other revisions' do
        headers = { accept: header_for_revision(revision + 1) }
        allow(request).to receive(:headers).and_return(headers)

        expect(constraint.matches?(request)).to eq false
      end
    end

    context 'when default is true' do
      subject(:constraint) { described_class.new(revision: revision, default: true) }

      it 'matches requests including the versioned vendor mime type' do
        headers = { accept: header_for_revision(revision) }
        allow(request).to receive(:headers).and_return(headers)

        expect(constraint.matches?(request)).to eq true
      end

      it 'matches requests when default is true' do
        headers = { accept: header_for_revision(revision + 1) }
        allow(request).to receive(:headers).and_return(headers)

        expect(constraint.matches?(request)).to eq true
      end
    end
  end
end
