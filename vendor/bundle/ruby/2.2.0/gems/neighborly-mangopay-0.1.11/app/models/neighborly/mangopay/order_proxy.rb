module Neighborly::Mangopay
  class OrderProxy
    I18N_SCOPE = 'neighborly.mangopay.order'

    delegate :amount, :amount_escrowed, :description, :meta,
      :reload, :save, :direct_card_payin, to: :order

    attr_reader :project

    def initialize(project)
      @project = project
    end

    def direct_card_payin(payin_params)
      begin
        @payin = ::RecursiveOpenStruct.new(::MangoPay::PayIn::Card::Direct.create(payin_params))
      rescue
        puts "Error raised"
      end
      return @payin
    end

    private

    def order(order_key)
      begin
        @order ||= ::MangoPay::PayIn.fetch(order_key)
      rescue Exception => e
        puts e.message
      end
    end
  end
end
