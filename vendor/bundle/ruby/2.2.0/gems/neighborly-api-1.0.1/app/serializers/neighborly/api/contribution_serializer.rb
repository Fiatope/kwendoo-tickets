module Neighborly::Api
  class ContributionSerializer < ActiveModel::Serializer
    def rights
      {
        can_pendent: object.can_pendent?,
        can_wait_confirmation: object.can_wait_confirmation?,
        can_confirm: object.can_confirm?,
        can_cancel: object.can_cancel?,
        can_request_refund: object.can_request_refund?,
        can_refund: object.can_refund?,
        can_push_to_trash: object.can_push_to_trash?
      }
    end

    attributes :id,
      :project_id,
      :user_id,
      :reward_id,
      :value,
      :confirmed_at,
      :created_at,
      :anonymous,
      :key,
      :credits,
      :payment_method,
      :payment_token,
      :payment_id,
      :address_street,
      :address_number,
      :address_complement,
      :address_neighborhood,
      :address_zip_code,
      :address_city,
      :address_state,
      :address_phone_number,
      :payment_choice,
      :payment_service_fee,
      :state,
      :short_note,
      :payment_service_fee_paid_by_user,
      :matching_id,
      :rights
  end
end
