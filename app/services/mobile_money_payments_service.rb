class MobileMoneyPaymentsService

  attr_accessor :params

  def initialize(params)
    @params = params
  end


  def initiate_payment_request_for(resource)
    @payingaccountidatsp = params[:payingaccountidatsp]
    # Automatic provider detection
    @paymentspid =  case params[:payingaccountidatsp].first(5)
                    when "25078"
                      ENV["OLTRANZ_PAYMENT_GATEWAY_PAYMENTSPID_MTN"]
                    when "25072"
                      ENV["OLTRANZ_PAYMENT_GATEWAY_PAYMENTSPID_TIGO"]
                    when "25073"
                      ENV["OLTRANZ_PAYMENT_GATEWAY_PAYMENTSPID_AIRTEL"]
                    else
                      return nil
                    end

    @descr = "KWENDOO-T-P#{resource.project.id}-#{resource.class.name.first}#{resource.id}" # There is a 140 characters limit      
    @transid = "#{resource.project.id * 1_000_000_000 + resource.id}" # Must be integer, max length is 14 characters
    @amount = resource.value.to_i

    resource.update_column(:transaction_reference, @descr)
    
    # Doc said 'http://IP:Port/PaymentGateway/payments/paymentRequest'
    uri = URI(ENV['OLTRANZ_PAYMENT_GATEWAY_IP_WITH_PORT'] + ENV['OLTRANZ_PAYMENT_GATEWAY_PATH'])
    xml_string = ERB.new(File.read(Rails.root + "app/views/oltranz/payment_request.xml.erb")).result(binding).gsub(/\s+/, "")

    # puts "-----------------------------"
    # puts xml_string
    # puts "-----------------------------"

    
    res = Net::HTTP.start(uri.host, uri.port, use_ssl: (ENV["OLTRANZ_PAYMENT_GATEWAY_USE_SSL"] == "true")) do |http|
      req = Net::HTTP::Post.new(uri)
      req['Content-Type'] = 'application/xml'
      req['CMD'] = '001'
      req['Domain'] = 'paymentgw'
      req.body = xml_string
      http.request(req)
    end
  end

  def send_final_confirmation_request(contribution)
    @transid = contribution.transaction_number
    # Doc said 'http://ip:port/PaymentGateway/payments/paymentResponseConfirmation'
    uri = URI.parse(ENV['OLTRANZ_PAYMENT_GATEWAY_IP_WITH_PORT'] + ENV['OLTRANZ_PAYMENT_GATEWAY_PATH'])
    xml_string = ERB.new(File.read(Rails.root + "app/views/oltranz/payment_completion.xml.erb")).result(binding)

    res = Net::HTTP.start(uri.host, uri.port, use_ssl: (ENV["OLTRANZ_PAYMENT_GATEWAY_USE_SSL"] == "true")) do |http|
      req = Net::HTTP::Post.new(uri)
      req['Content-Type'] = 'application/xml'
      req['CMD'] = '001'
      req['Domain'] = 'paymentgw'
      req.body = xml_string
      http.request(req)
    end
    res
  end

end
