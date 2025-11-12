class WecashupController < ApplicationController
  layout false

  def create
    require 'uri'
    require 'json'
    require 'open-uri'
    require 'net/https'
      # ************************************************************************************
      #         STEP 1 - CONFIGURATION : START
      # Find your merchant UID, Public Key and secret code on the
      #     home page of your merchant dashboard
      # *************************************************************************************
    @merchant_uid = ENV["MERCHANT_UID"]
    @merchant_public_key = ENV["MERCHANT_PUBLIC_KEY"]
    @merchant_secret = ENV["MERCHANT_SECRET"]
      # /*************************************************************************************
      # STEP 2 - CREATING AND GETTING THE POST REQUEST VARIABLES : START
      # Create and initialize variables to be sent to confirm that
      # the ongoing transaction is associated with the current merchant
      # **************************************************************************************
      # //extracting data from the post
    @transaction_uid = params["transaction_uid"]
    @transaction_token = params["transaction_token"]
    @transaction_provider_name = params["transaction_provider_name"]
    @transaction_confirmation_code = params["transaction_confirmation_code"]
      # /*****************************************************************************************
      # STEP 3 - SAVING THE POST REQUEST VARIABLES IN DATABASE : START
      # Before doing anything, save the 4 variables that we just got from the POST request in your database.
      # This will be useful for further operations to authenticate the requests sent to the default webhook url
      # Save the transaction in your database with | transaction_uid | transaction_token | transaction_provider_name | transaction_confirmation_code
      # *******************************************************************************************/
    @transaction = Wecashuptransaction.new(
      transaction_uid: @transaction_uid,
      transaction_token: @transaction_token,
      transaction_provider_name: @transaction_provider_name,
      transaction_confirmation_code: @transaction_confirmation_code)
      if @transaction.save
        p "New wecashup transaction created"
      end
      # /******************************************************************************************
      # STEP 4 - BUILDING THE WECASHUP URL WHERE TO POST THE TRANSACTION CONFIRMATION DATA : START
      # The endpoint is https://www.wecashup.com/api/v1.0/
      # build your URL by adding /merchants/{YOUR-MERCHANT-UID}/transactions/{THE-TRANSACTION-UID-GOTTEN-IN-THE-RECEIVED-POST-REQUEST}/?merchant_public_key={YOUR-PUBLIC-KEY}
      # *******************************************************************************************/

      # Building the url where to send the transaction confirmation data
    @url = 'https://www.wecashup.com/api/v1.0/merchants/' + @merchant_uid + '/transactions/' + @transaction_uid + '/?merchant_public_key=' + @merchant_public_key

      # /******************************************************************************************
      # STEP 5 - SETTING UP THE VARIABLES ARRAY TO BE POSTED TO WECASHUP TO CONFIRM THE TRANSACTION : START
      # The endpoint is https://www.wecashup.com/api/v1.0/
      # build your URL by adding /merchants/{YOUR-MERCHANT-UID}/transactions/{THE-TRANSACTION-UID-GOTTEN-IN-THE-RECEIVED-POST-REQUEST}/?merchant_public_key={YOUR-PUBLIC-KEY}
      # *******************************************************************************************/

      # Build hash to be sent to API via HTTP Post request
    fields = {
      'merchant_secret' => URI.encode(@merchant_secret),
      'transaction_token' => URI.encode(@transaction_token),
      'transaction_uid' => URI.encode(@transaction_uid),
      'transaction_confirmation_code' => URI.encode(@transaction_confirmation_code),
      'transaction_provider_name' => @transaction_provider_name,
      '_method' => URI.encode('PATCH')
    }
    p fields
    response_data = {}
      # /******************************************************************************************
      # STEP 6 - PREPARE THE POST REQUEST, EXECUTE IT AND GET THE RESPONSE : START
      # Initialize PHP curl to execute an HTTP POST request to send the received data to WeCashUp
      # Receive server response and parse it to JSON
      # *******************************************************************************************/
      # Setting up HTTP client with HTTPClient gem (doc: http://www.rubydoc.info/gems/httpclient/2.1.5.2/HTTPClient)
    client = HTTPClient.new
    # Desabling timeout (API requests can be quite long)
    client.receive_timeout = 100000
    # Processing HTTP Post request to API and storing result
    result = client.post(@url, fields)
    p "Result"
    p result
    # Parsing it to JSON
    if result.present?
        response_data = JSON.parse(result.body)
        p "Parsed data"
        p response_data
    end
  #       /******************************************************************************************
  #       STEP 7 - PROCESS THE RESPONSE AND TAKE ACTION : START
  #       a) Extract the useful data from the response and save them.
  #       b) Processing : If the response state the transaction as successful, do whatever you want to let the
  #       customer know that his transaction was successful and take action (like launching the delivery
  #       process or whatever is relevant for you)
  #       If it is not successfull, do wathever you want
  #       *******************************************************************************************/

  #       //a) Extract the relevant data like the transaction_uid and transaction_status and save them n your database or just update the previously saved data.
    if response_data["response_status"] == "success"
      @contribution = Contribution.find(response_data["response_content"]["transaction"]["transaction_receiver_reference"])
      @user = User.find(response_data["response_content"]["transaction"]["transaction_sender_reference"])

      transaction_uid_response = response_data["response_content"]["transaction"]["transaction_uid"]

      @transaction.currency = response_data["response_content"]["transaction"]["transaction_sender_currency"]
      @transaction.value = response_data["response_content"]["transaction"]["transaction_receiver_total_amount"]
      @transaction.conversion_rate = response_data["response_content"]["transaction"]["transaction_conversion_rate"]
      @contribution.payment_method = "wecashup"
      @contribution.payer_name = @user.name
      @contribution.payer_email = @user.email
      puts "Contribution value"
      p @contribution.value
      puts "Conversion rate"
      @transaction.contribution = @contribution
      puts "changing state"
      @contribution.state_event = :wait_confirmation
      @transaction.save
      @contribution.save
      puts "saved"
        #//b) Process the response.
      if response_data.present? && response_data["response_status"] == "success" && @transaction.created_at.present? && @contribution.state == "waiting_confirmation"
        # Send email
        @contribution.notify_owner(:wecashup_payment_waiting_confirmation)
        # Redirect outside Wecashup frame
        location = "https://tickets.kwendoo.rw/#{@contribution.project.permalink}"
        render html: "<script>top.window.location = '#{location}'</script>".html_safe
      else
        redirect_to wecashup_error_path, :layout => false
      end
    else
      render wecashup_error_path, :layout => false
    end
  end

  def wecashup_error
    response.headers["X-FRAME-OPTIONS"] = "ALLOW-FROM http://piggybanktest.pagekite.me/" and return
  end

  def update
    # // Create and initialize variables to be sent to confirm the that the ongoing transaction is associated with the current merchant
    # //extracting data from the post
    puts "Received confirmation data from wecashup"
    merchant_secret =  ENV["MERCHANT_SECRET"]

    if params["merchant_secret"].present?
      received_merchant_secret = params['merchant_secret']
      puts "Received merchant_secret from Wecashup"
    end

    if params['transaction_uid'].present?
      received_transaction_uid = params['transaction_uid']
      puts "Received transaction_uid from Wecashup"
    end

    if params['transaction_status'].present?
      received_transaction_status = params['transaction_status']
      puts "Received transaction_status from Wecashup"
    end

    if params['transaction_details'].present?
      received_transaction_details = params['transaction_details']
      puts "Received transaction_details from Wecashup"
    end

    if params['transaction_token'].present?
      received_transaction_token = params['transaction_token']
      puts "Received transaction_token from Wecashup"
    end

    if params['transaction_type'].present?
      received_transaction_type = params['transaction_type']
      puts "Received transaction_type from Wecashup"
    end


    # //Authentification | We make sure that the received data come from a system that knows our secret key (WeCashUp only)
    if received_merchant_secret == merchant_secret
      # //received_transaction_merchant_secret is Valid
      puts "Secret merchant keys match"
      # //Now check if you have a transaction with the received_transaction_uid and received_transaction_token
      if Wecashuptransaction.find_by(transaction_uid: received_transaction_uid).present? && Wecashuptransaction.find_by(transaction_token: received_transaction_token).present?
        # //received_transaction_merchant_secret is Valid
        puts "Transaction tokens match, Wecashup authenticated"
        authenticated = true
        @transaction = Wecashuptransaction.find_by(transaction_uid: received_transaction_uid)
        p @transaction
        @contribution = @transaction.contribution
        p @contribution
      end
    end

    if authenticated == true
      # Update and process your transaction
      if received_transaction_status == "PAID"
        # //Save the transaction status in your database and do wathever you want to tell the user that it's transaction succeed
        puts "Transaction paid"
        @contribution.notify_owner(:payment_confirmed)
        @contribution.state_event = :confirm
        @contribution.save
        puts "Went through the whole success process"
      else
        # //Save the transaction status in your database and do wathever you want to tell the user that it's transaction failed
        puts "Transaction failed"
        @contribution.notify_owner(:wecashup_failed)
        @contribution.state_event = :cancel
        @contribution.save
        puts "Went through the whole fail process"
      end
    else
      puts "Authentication failed"
    end
  end
end

