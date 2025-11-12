module MigsPaymentsHelper

  # This method generates a payment URI for the MIGS 
  def payment_initialization_uri_for(resource)
    # Guesses a vpc_OrderInfo for the payment based on the resource
    info = "KWENDOO-T-P#{resource.project.id}-#{resource.class.name.first}#{resource.id}" # There is a 34 characters limit      

    # Collects the query parameters required by the MIGS integration instructions
    query_hash = {
      vpc_AccessCode: ENV["MASTERCARD_ACCESS_CODE"],
      vpc_Amount: resource.value.to_i,
      vpc_Command: "pay",
      vpc_Currency: "RWF",
      vpc_Locale: I18n.locale,
      vpc_Merchant: ENV["MASTERCARD_MERCHANT_ID"],
      vpc_MerchTxnRef: [info, Time.now.to_i.to_s].join("-"),
      vpc_OrderInfo: [info, Time.now.to_i.to_s].join("-"),
      vpc_ReturnURL: url_for(action: 'vpc_payment',
                             controller: "projects/#{resource.class.name.downcase.pluralize}",
                             id: resource.id,
                             only_path: false,
                             protocol: "#{Rails.env.development? ? 'http' : 'https'}"),
      vpc_Version: 1
    }

    # Sorts the query hash keys and builds the query string
    query_string = query_hash.sort.to_h.map{ |k, v| "#{k}=#{v}" }.join("&")

    # Hashes the query string, excluding vpc_SecureHash and vpc_SecureHashType
    digest = OpenSSL::HMAC.hexdigest(
      OpenSSL::Digest.new('sha256'),
      [ENV["MASTERCARD_SECURE_HASH_SECRET"]].pack('H*'),
      query_string
    ).upcase
    
    # Builds the URI and appends vpc_SecureHash and vpc_SecureHashType
    ["https://", ENV["MASTERCARD_VIRTUAL_PAYMENT_CLIENT_HOST"], '/vpcpay', '?', 
      query_string, "&vpc_SecureHash=", digest, "&vpc_SecureHashType=", "SHA256"].join
  end

end
