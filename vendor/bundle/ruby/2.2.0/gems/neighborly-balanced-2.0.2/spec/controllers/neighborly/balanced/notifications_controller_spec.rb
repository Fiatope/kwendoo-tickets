require 'spec_helper'



  describe 'POST \'create\'' do
    context 'with debit.created notification' do
      let(:params) do
        attributes_for_notification('debit.created')
      end

      it_behaves_like 'create action'
    end

    context 'with debit.succeeded notification' do
      let(:params) do
        attributes_for_notification('debit.succeeded')
      end

      it_behaves_like 'create action'
    end

    context 'with bank_account_verification.deposited notification' do
      let(:params) do
        attributes_for_notification('bank_account_verification.deposited')
      end

      it_behaves_like 'create action'
    end
  end
end
