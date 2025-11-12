require 'spec_helper'

describe Neighborly::Balanced::OrderProxy do
  subject { described_class.new(project) }
  before do
    allow_any_instance_of(Neighborly::Balanced::Customer).to receive(:fetch).
      and_return(customer)
    allow(Rails.application.routes).to receive(:url_helpers).
      and_return(double('rails router').as_null_object)
  end
  let(:project) { double('Project', href: '/FOOBAR').as_null_object }
  let(:customer) { double('Customer').as_null_object }

  it 'does not trigger request to Balanced until calling methods delegated to order' do
    expect(Balanced::Order).to_not receive(:find)
    expect_any_instance_of(Balanced::Customer).to_not receive(:create_order)
    subject.user
  end

  describe 'methods of order' do
    let(:balanced_order) do
      double('Neighborly::Balanced::Order', amount: 42).as_null_object
    end
    before do
      allow(Neighborly::Balanced::Order).to receive(:create!)
    end

    context 'when there is no order yet' do
      before do
        allow(Neighborly::Balanced::Order).to receive(:find_by)
        allow(customer).to receive(:create_order).and_return(balanced_order)
      end

      it 'creates one in Balanced' do
        expect(customer).to receive(:create_order)
        subject.amount
      end

      it 'creates one in app database' do
        expect(Neighborly::Balanced::Order).to receive(:create!)
        subject.amount
      end

      it 'defines a description' do
        expect(balanced_order).to receive(:description=)
        subject.amount
      end

      it 'defines meta information' do
        expect(balanced_order).to receive(:meta=)
        subject.amount
      end

      it 'delegates to order object' do
        expect(subject.amount).to eql(42)
      end
    end

    context 'when there is already an order' do
      before do
        allow(Neighborly::Balanced::Order).to receive(:find_by).
          and_return(order)
        allow(Balanced::Order).to receive(:find).and_return(balanced_order)
      end
      let(:order) { double('Order').as_null_object }

      it 'skips creation of new one in Balanced' do
        expect(customer).to_not receive(:create_order)
        subject.amount
      end

      it 'skips creation of new one in app database' do
        expect(Neighborly::Balanced::Order).to_not receive(:create!)
        subject.amount
      end

      it 'fetches the existing' do
        expect(Balanced::Order).to receive(:find)
        subject.amount
      end

      it 'delegates to order object' do
        expect(subject.amount).to eql(balanced_order.amount)
      end
    end
  end
end
