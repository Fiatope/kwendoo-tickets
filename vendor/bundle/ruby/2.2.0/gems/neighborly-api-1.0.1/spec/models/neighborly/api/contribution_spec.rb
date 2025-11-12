require 'spec_helper'

describe Neighborly::Api::Contribution do
  describe '.between_values' do
    it 'returns the contributions with value between 15 and 20' do
      FactoryGirl.create(:contribution, value: 10)
      FactoryGirl.create(:contribution, value: 15)
      FactoryGirl.create(:contribution, value: 20)
      FactoryGirl.create(:contribution, value: 21)

      expect(described_class.between_values(15, 20).size).to eq 2
    end

    it 'removes comma and transform it to float' do
      expect(described_class).to receive(:where).with('value between ? and ?', 1000.0, 2000.4)
      described_class.between_values('1,000', '2,000.40')
    end
  end

  describe '.by_project_id' do
    let(:first_project)  { FactoryGirl.create(:project, state: 'online') }
    let(:second_project) { FactoryGirl.create(:project, state: 'online') }

    before do
      FactoryGirl.create(:contribution, value: 10, project: first_project)
      FactoryGirl.create(:contribution, value: 10, project: second_project)
    end

    it 'returns the contributions from the first project' do
      expect(described_class.by_project_id(first_project.id).size).to eq 1
    end
  end
end
