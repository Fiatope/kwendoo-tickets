module Neighborly::Mangopay::Creditcard
  class PaymentsController < ActionController::Base
    before_filter :authenticate_user!

    def new
      @customer = customer
      @cards = []
      current_user.registered_cards_with_currency(params[:currency]).each do |rc|
        begin
          @cards << RecursiveOpenStruct.new(::MangoPay::Card.fetch(rc.key))
        rescue Exception => e
          if e.code.to_i == 404
            rc.destroy
          end
        end
      end

      @new_card_request = RecursiveOpenStruct.new(
                            ::MangoPay::CardRegistration.create({
                              UserId: @customer.Id,
                              Currency: params[:currency],
                              Tag: 'Test Card Registration'
                            })
                          )
    end

    def create
      checkout_hash = resource_params
      if resource_params.fetch(:use_card).present? && resource_params.fetch(:use_card) != "new"
        checkout_hash[:card_key] = resource_params.fetch(:use_card)
      else
        checkout_hash[:card_key] = attach_card_to_customer
      end

      return_url = secured_return_url(resource.id)

      payment = Payment.new('mangopay-creditcard',
                             customer,
                             resource,
                             return_url,
                             checkout_hash)
      begin
        debit = payment.debit!
      rescue
        resource.cancel!
      end

      if debit.try(:Status) == "SUCCEEDED"
        payment.checkout!
        redirect_to(*checkout_response_params(resource, payment.successful?))
      else
        if debit.try(:SecureModeNeeded) && debit.try(:SecureModeRedirectURL).present?
          resource.update_attributes(
            payment_id:                       debit.try(:Id),
            payment_method:                   'mangopay-creditcard',
            payment_service_fee:              0,
            payment_service_fee_paid_by_user: false
          )
          redirect_to debit.SecureModeRedirectURL and return
        else
          resource.cancel! unless resource.state == "canceled"
          if debit.try(:ResultCode) == "001011"
            flash.alert = t('neighborly.mangopay.creditcard.payments.confirm_secured_payment.errors.transaction_overall')
            redirect_to main_app.mangopay_authentications_user_path(current_user)
          elsif debit.try(:ResultCode) == "101410" # Card invalid
            current_user.registered_cards.where(key: debit.try(:CardId)).first.delete
            redirect_to(*checkout_response_params(resource, false, t('neighborly.mangopay.creditcard.payments.confirm_secured_payment.errors.card_invalid')))
          else
            redirect_to(*checkout_response_params(resource, false))
          end
        end
      end
    end

    def confirm_secured_payment
      if params[:transactionId] != resource_from_3d_secure.payment_id
        resource_from_3d_secure.cancel
        redirect_to(*checkout_response_params(resource_from_3d_secure, false))
      elsif MangoPay::PayIn.fetch(params[:transactionId])['ResultCode'] == '000000'
        resource_from_3d_secure.confirm!
        redirect_to(*checkout_response_params(resource_from_3d_secure, true))
      else
        resource_from_3d_secure.cancel
        redirect_to(*checkout_response_params(resource_from_3d_secure, false))
      end
    end

    private
    def resource
      @resource ||= if params[:payment][:match_id].present?
                      Match.find(params[:payment].fetch(:match_id))
                    else
                      Contribution.find(params[:payment].fetch(:contribution_id))
                    end
    end

    def resource_from_3d_secure
      @resource ||= if params[:match_id].present?
                      Match.find(params[:match_id])
                    else
                      Contribution.find(params[:contribution_id])
                    end
    end

    def resource_name
      resource.class.model_name.singular.to_sym
    end

    def checkout_response_params(resource, success, custom_error = nil)
      inner_error = custom_error || t('.errors.default')
      status = success ? :succeeded : :failed
      route_params = [resource.project.permalink, resource.id]

      {
        contribution: {
          succeeded: [
            main_app.project_contribution_path(*route_params)
          ],
          failed: [
            main_app.edit_project_contribution_path(*route_params),
            alert: inner_error
          ]
        },
        match: {
          succeeded: [
            main_app.project_match_path(*route_params)
          ],
          failed: [
            main_app.edit_project_match_path(*route_params),
            alert: inner_error
          ]
        }
      }.fetch(resource_name).fetch(status)
    end

    def resource_params
      params.require(:payment).
             permit(:contribution_id,
                    :match_id,
                    :use_card,
                    :pay_fee,
                    :card_number,
                    :security_code,
                    :expiration_month,
                    :expiration_year,
                    user: {})
    end

    def card_params
      params.permit(
        :access_key,
        :preregistration_data,
        :card_registration_url,
        :card_id
      )
    end

    # Return the card Id
    def attach_card_to_customer
      month_value = resource_params.fetch(:expiration_month).to_s
      month_formatted = month_value.length == 1 ? "0#{month_value}" : month_value

      data = {
        data: card_params.fetch(:preregistration_data),
        accessKeyRef: card_params.fetch(:access_key),
        cardNumber: resource_params.fetch(:card_number),
        cardExpirationDate: month_formatted + resource_params.fetch(:expiration_year).to_s[2..4],
        cardCvx: resource_params.fetch(:security_code)
      }
      res = Net::HTTP.post_form(URI(card_params.fetch(:card_registration_url)), data)
      raise Exception, [res, res.body] unless (res.is_a?(Net::HTTPOK) && res.body.start_with?('data='))

      final_card_info = ::RecursiveOpenStruct.new(::MangoPay::CardRegistration.update(card_params.fetch(:card_id), {
                            RegistrationData: res.body
                          })
                        )
      current_user.registered_cards.create!(key: final_card_info.try(:CardId), currency: final_card_info.try(:Currency))
      return final_card_info.try(:CardId)
    end

    def customer
      @customer ||= ::RecursiveOpenStruct.new(Neighborly::Mangopay::Customer.new(current_user, params).fetch)
    end

    def update_customer
      Neighborly::Mangopay::Customer.new(current_user, params).update!
    end
  end
end
