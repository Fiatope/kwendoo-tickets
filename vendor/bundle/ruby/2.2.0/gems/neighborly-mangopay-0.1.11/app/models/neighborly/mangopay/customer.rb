module Neighborly::Mangopay
  class Customer
    def initialize(user, request_params)
      @user = user
      @request_params = request_params
    end

    def fetch
      key = @user.mangopay_contributor_by_type.key
      @customer ||= if key
        ::RecursiveOpenStruct.new(::MangoPay::User.fetch(key))
      else
        create!
      end
    end

    def update!
      begin
        if @user.profile_type == "personal"
          begin
            customer = ::MangoPay::NaturalUser.update( @user.mangopay_contributor_by_type.key,
                          Email:              @user.email,
                          FirstName:          @user.firstname,
                          LastName:           @user.lastname,
                          Birthday:           @user.birthday_to_timestamp,
                          Nationality:        @user.nationality,
                          CountryOfResidence: @user.residence_country,
                          Address:            @user.address
                    )
          rescue
            create! unless @user.mangopay_contributor_by_type.present?
          end
        elsif @user.profile_type == "organization"
          begin
            customer = ::MangoPay::LegalUser.update( @user.mangopay_contributor_by_type.key,
              Name:                                   @user.organization.name,
              Email:                                  @user.email,
              LegalPersonType:                        'ORGANIZATION',
              LegalRepresentativeFirstName:           @user.firstname,
              LegalRepresentativeLastName:            @user.lastname,
              LegalRepresentativeBirthday:            @user.birthday_to_timestamp,
              LegalRepresentativeNationality:         @user.nationality,
              LegalRepresentativeCountryOfResidence:  @user.residence_country,
              LegalRepresentativeAdress:              @user.address
            )
          rescue
            create! unless @user.mangopay_contributor_by_type.present?
          end
        else
          puts 'The user has no profile_type, contact the administrator please.'
        end
      rescue
        puts "Error"
      end
    end

    def mangopay_user_url_type(mango_key)
      if @user.profile_type == "organization"
        ::MangoPay::LegalUser.url(mango_key)
      else
        ::MangoPay::NaturalUser.url(mango_key)
      end
    end

    private

    def create!
      begin
        if @user.profile_type == "personal"
          customer = ::MangoPay::NaturalUser.create(
                        Email:              @user.email,
                        FirstName:          @user.firstname,
                        LastName:           @user.lastname,
                        Birthday:           @user.birthday_to_timestamp,
                        Nationality:        @user.nationality,
                        CountryOfResidence: @user.residence_country,
                        Address:            @user.address
                    )
        elsif @user.profile_type == "organization"
          customer = ::MangoPay::LegalUser.create(
            Name:                                   @user.organization.name,
            Email:                                  @user.email,
            LegalPersonType:                        'ORGANIZATION',
            LegalRepresentativeFirstName:           @user.firstname,
            LegalRepresentativeLastName:            @user.lastname,
            LegalRepresentativeBirthday:            @user.birthday_to_timestamp,
            LegalRepresentativeNationality:         @user.nationality,
            LegalRepresentativeCountryOfResidence:  @user.residence_country,
            LegalRepresentativeAdress:              @user.address
          )
        else
          raise 'The user has no profile_type, contact the administrator please.'
        end
        mangopay_user_id = customer["Id"]

        if @user.profile_type == "organization"
          @user.create_mangopay_organization_contributor(key: mangopay_user_id, href: mangopay_user_url_type(mangopay_user_id))
        else
          @user.create_mangopay_contributor(key: mangopay_user_id, href: mangopay_user_url_type(mangopay_user_id))
        end
        ::RecursiveOpenStruct.new(customer)
      rescue
        puts "Error"
      end
    end

    def user_params
      @request_params.permit(payment: [user: %i(
                                             name
                                             birthday
                                             nationality
                                             residence_country
                                             address_street
                                             address_city
                                             address_state
                                             address_zip_code
                                           )])[:payment][:user]
    end
  end
end
