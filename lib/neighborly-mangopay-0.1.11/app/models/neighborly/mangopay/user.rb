module Neighborly::Mangopay::User
  extend ActiveSupport::Concern
  included do
    has_one :mangopay_contributor, class_name: 'Neighborly::Mangopay::Contributor', foreign_key: 'user_id'
    has_one :mangopay_organization_contributor, class_name: 'Neighborly::Mangopay::Contributor', foreign_key: 'organization_id'
    has_one :bank_information, class_name: 'Neighborly::Mangopay::BankInformation'
    has_many :registered_cards, class_name: 'Neighborly::Mangopay::RegisteredCard'
    has_many :orders, class_name: 'Neighborly::Mangopay::Order'
    has_many :kycs, class_name: 'Neighborly::Mangopay::Kyc'

    accepts_nested_attributes_for :kycs, :reject_if => :all_blank, :allow_destroy => true

    # before_update :update_mangopay_user # DISABLED — MangoPay deprecated

    def registered_cards_with_currency(currency)
      registered_cards.where(currency: currency)
    end

    def firstname
      if name.present?
        name.split(' ').first
      end
    end

    def lastname
      if name.present?
        name.split(' ').last
      end
    end

    def address
      "#{address_number.to_s} #{address_street.to_s} #{address_complement}, #{address_zip_code.to_s}, #{address_city.to_s}"
    end

    def light_authentication_ready?
      if profile_type == "personal"
        return firstname.present? && lastname.present? && nationality.present? && residence_country.present? && birthday.present? 
      else
        return firstname.present? && lastname.present? && nationality.present? && residence_country.present? && birthday.present? && organization.present? && organization.name.present?
      end
    end

    def birthday_to_timestamp
      birthday.to_time.to_i
    end

    # DISABLED — MangoPay deprecated
    def mangopay_contributor_key
      return mangopay_contributor_by_type.try(:key)
    end

    def refund_ready?
      return bank_information.present? && bank_information.key.present?
    end

    # DISABLED — MangoPay deprecated
    def mangopay_document(kyc_object)
      Rails.logger.warn "[MangoPay] mangopay_document called but MangoPay is deprecated — skipping"
      nil
    end

    def document_types
      if profile_type == "personal"
        Neighborly::Mangopay::Kyc.natural_document_type
      else
        Neighborly::Mangopay::Kyc.legal_document_type
      end
    end

    def kycs_available_type
      document_types - kycs.pluck(:proof_type)
    end

    # DISABLED — MangoPay deprecated
    def kycs_updatable_elements
      []
    end

    # DISABLED — MangoPay deprecated
    def kycs_displayable_elements
      []
    end

    # DISABLED — MangoPay deprecated
    def kycs_validated_elements
      []
    end

    # DISABLED — MangoPay deprecated
    def kycs_articles_of_association_elements
      []
    end

    # DISABLED — MangoPay deprecated
    def kycs_registration_proof_elements
      []
    end

    # DISABLED — MangoPay deprecated
    def update_mangopay_user
      Rails.logger.warn "[MangoPay] update_mangopay_user called but MangoPay is deprecated — skipping"
      true
    end

    def mangopay_contributor_by_type
      if profile_type == "organization"
        mangopay_organization_contributor
      else
        mangopay_contributor
      end
    end

  end
end
