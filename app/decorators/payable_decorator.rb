class PayableDecorator < Draper::Decorator
  include Draper::LazyHelpers

  def display_value
    s = "#{object.project.currency_sym}#{object.value}"
    s = "#{object.value}#{object.project.currency_sym}" if object.project.currency_sym == '€'
    cfa_value = object.value * conversion_rate
    if object.payment_method == "Orange Money"
      "#{cfa_value.round} CFA (= #{s})"
    else
      # 14/04/2020 : To delete (= XX CFA)
      # "#{s} (= #{cfa_value.round} CFA)"
      s
    end
  end

  def conversion_rate
    ENV['CFA_CONVERSION_RATE'].to_f || 656
  end

  def display_confirmed_at
    I18n.l(object.confirmed_at.to_date) if object.confirmed_at
  end
end
