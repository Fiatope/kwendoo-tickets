class Projects::ContributionsController < ApplicationController
  after_action :verify_authorized, except: [:index, :tickets_show]
  inherit_resources
  # skip_before_action :set_persistent_warning
  before_action :has_mangopay_prerequisites, only: [:edit]
  #before_action :has_mangopay_prerequisites, only: [:new, :create]
  skip_before_action :verify_authenticity_token, only: :orange_money_payment_confirmation
  skip_after_action :verify_authorized, only: [:cancel, :orange_money_payment_confirmation, :pay_plus_africa_payment_confirmation, :mobile_money_payment_confirmation, :touch_payment_initialization]

  has_scope :available_to_count, type: :boolean
  has_scope :with_state
  has_scope :page, default: 1

  def index
    @project        = parent
    @contributions  = collection
    @project_tickets  = Ticket.list_of_tickets(@project)
    @active_matches = parent.matches.active
    if request.xhr? && params[:page] && params[:page].to_i > 1
      render collection
    end
  end


  def tickets_index
    @project        = parent
    @contribution   = resource
    authorize resource
    if @contribution.state == "canceled"
      flash.notice = "This order has been canceled. Please place a new one!"
      redirect_to project_path(@project) and return
    elsif @contribution.state != "confirmed" && !@project.is_prebooked?
      flash.notice = "This order has not been paid. Please finalize it before downloading your tickets."
      redirect_to edit_project_contribution_path(@project, @contribution) and return
    elsif @contribution.state == "confirmed" || @project.is_prebooked?
      respond_to do |format|
        format.html
        format.pdf do
          render :pdf => "#{@project.permalink}_tickets",
            :disposition => "inline",
            :template => "projects/contributions/tickets_index.pdf.slim"
        end
      end
      # render "tickets_index", formats: :pdf
    end
  end

  def tickets_show
    @project      = parent
    @contribution = resource
  end

  def edit
    @project      = parent
    @contribution = resource

    puts "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"
    puts @contribution.inspect
    puts "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"

    authorize resource

    if !@contribution.user
      @contribution.user = current_user
      @contribution.save!
    end

    if @contribution.state == "canceled"
      puts "contribution.state => canceled canceled canceled"
      puts "contribution.state => canceled canceled canceled"

      flash.notice = "This order has been canceled. Please create a new one!"
      redirect_to project_path(@project)
    elsif @contribution.state == "confirmed"
      puts "contribution.state => confirmed confirmed confirmed"
      puts "contribution.state => confirmed confirmed confirmed"

      @contribution.notify_owner(:payment_confirmed)
      
      NotificationsMailer.with(contribution: @contribution).payment_confirmed.deliver

      redirect_to project_contribution_path(parent, resource)
    elsif @contribution.project.is_prebooked?

      puts "preboopreboopreboopreboopreboo"
      puts "preboopreboopreboopreboopreboo"

      @contribution.confirm!
      redirect_to project_contribution_path(parent, resource)
    end

    if @project.id == 25
      @bg_sm = "bg-small"
    end
  end

  def show
    @project      = parent
    @contribution = resource
    authorize resource

    if @contribution.state == "confirmed" || @contribution.project.is_prebooked?
      flash.notice = "Your order has been confirmed!"
    elsif @contribution.state == "canceled"
      flash.notice = "This order has been canceled. Please create a new one!"
      redirect_to project_path(@project) and return
    else
      redirect_to edit_project_contribution_path(@project, @contribution)
    end

    if @project.id == 25
      @bg_sm = "bg-small"
    end
  end

  def new
    @project      = parent
    @contribution = ContributionForm.new(project: parent, user: current_user)
    @reward_categories = @contribution.reward_categories
    @ticket_categories_orders = {}
    @project.rewards.select { |r| !r.sold_out? }.each do |r|
      @ticket_categories_order = @contribution.ticket_categories_orders.build(reward_id: r.id)
      @ticket_categories_orders[@ticket_categories_order.reward.reward_category_id] = [] unless @ticket_categories_orders.key? @ticket_categories_order.reward.reward_category_id
      @ticket_categories_orders[@ticket_categories_order.reward.reward_category_id] << @ticket_categories_order
    end
    @contribution.currency = params[:currency]
    authorize @contribution

    @rewards = [empty_reward] + @project.rewards.not_soon.remaining.order(:minimum_value)

    if params[:reward_id] && (selected_reward = @project.rewards.not_soon.find(params[:reward_id])) && !selected_reward.sold_out?
      @contribution.reward = selected_reward
      @contribution.value = "%0.0f" % selected_reward.minimum_value
    end
    if @project.id == 25
      @bg_sm = "bg-small"
    end
  end

  def create
    require 'open-uri'
    require 'json'
    # Create contribution. Currency is initialized in local currency (not EUR).
    @project      = parent
    @contribution = ContributionForm.new(permitted_params[:contribution_form].
                                     merge(user: current_user,
                                           project: parent))

    permitted_user_tickets = permitted_params[:user_tickets].present? ? permitted_params[:user_tickets].to_unsafe_h : {}

    user_tickets = {}
    permitted_user_tickets.each_value do |permitted_user_ticket|
      user_ticket = permitted_user_ticket.values[2]
      user_tickets[user_ticket[0]] = permitted_user_ticket
    end

    if(permitted_user_tickets["0"])
      Rails.cache.write('user_tickets', permitted_user_tickets["0"]) unless user_tickets.empty?
    elsif (permitted_user_tickets["1"])
      Rails.cache.write('user_tickets', permitted_user_tickets["1"]) unless user_tickets.empty?
    else
      Rails.cache.write('user_tickets', permitted_user_tickets["2"]) unless user_tickets.empty?
    end

    Rails.cache.write('promotion_tickets', user_tickets) unless user_tickets.empty?

    @contribution.reward_id = nil if params[:contribution_form][:reward_id].to_i == 0
    authorize @contribution

    @contribution.cfa_value = 656

    if @contribution.save
      Rails.cache.delete('promotion_tickets') if Rails.cache.exist?('promotion_tickets')
      session[:thank_you_contribution_id] = @contribution.id
      flash.delete(:notice)
      redirect_to edit_project_contribution_path(project_id: @project, id: @contribution.id)
    else
      flash.alert = t('controllers.projects.contributions.create.error')
      @rewards = [empty_reward] + @project.rewards.not_soon.remaining.order(:minimum_value)

      render "new"
    end
  end

  
  def cancel
    if resource.user == current_user
      @contribution = resource
      @contribution.orange_money_transactions.update_all(status_string: "CANCELLED")
      response_message = t('controllers.projects.contributions.cancel.error')
      @contribution.update(
        response_code: "CANCELLED",
        transaction_number: @contribution.orange_money_transactions.where("txnid is not null").last.try(:txnid),
        response_message: response_message,
        payment_method: "Orange Money"
      )
      @contribution.state_event = :cancel
      @contribution.save!
      redirect_to edit_project_contribution_path(@contribution.project, @contribution), alert: response_message
    else
      redirect_to root_path, alert: "You are not authorized to cancel this contribution"
    end
  end

  def credits_checkout
    @contribution = resource
    authorize resource
    if current_user.credits < @contribution.value
      flash.alert = t('controllers.projects.contributions.credits_checkout.no_credits')
      return redirect_to new_project_contribution_path(@contribution.project)
    end

    unless @contribution.confirmed?
      @contribution.update({ payment_method: 'Credits' })
      @contribution.confirm!
    end

    flash.notice = t('controllers.projects.contributions.credits_checkout.success')
    redirect_to project_contribution_path(parent, resource)
  end

  def issue_free_tickets
    @project      = parent
    @contribution = resource
    authorize @contribution
    @contribution.assign_attributes({ payment_method: "Free" })
    @contribution.notify_owner(:payment_confirmed)
    @contribution.state_event = :confirm
    @contribution.save
    flash.notice = t('controllers.projects.contributions.free_tickets.success')
    redirect_to tickets_show_project_contribution_path(@project, @contribution)
  end


  def orange_money_payment_initialization
    @contribution = resource
    authorize @contribution

    transaction = OrangeMoneyService.initialize_payment_for(@contribution)
    if transaction.status_string == "OK"
      redirect_to transaction.payment_url
    else
      redirect_to edit_project_contribution_path(@contribution.project, @contribution), alert: "Orange Money is temporarily unavailable. Please pick another payment method (#{transaction.status_string})"
    end
  end

  def pay_plus_africa_payment_initialization
    @contribution = resource
    authorize @contribution

    transaction = PayPlusAfricaService.initialize_payment_for(@contribution)

    # abort transaction.status_string

    puts "TTTTTTTTTTTTTTTTTTTTTTTTTTT"
    puts transaction.inspect
    puts "TTTTTTTTTTTTTTTTTTTTTTTTTTT"

    if transaction.status_string == "00"
      @payment_url = transaction.payment_url

      respond_to do |format|
        format.js {render layout: false}
      end
    else
      redirect_to edit_project_contribution_path(@contribution.project, @contribution), alert: "Payplus Africa is temporarily unavailable. Please pick another payment method (#{transaction.status_string})"
    end
  end


  def orange_money_payment_confirmation
    if params["status"] == "SUCCESS"
      transaction = OrangeMoneyTransaction.find_by(notif_token: params["notif_token"])
      transaction.update_column(:txnid, params["txnid"])
      @contribution = Contribution.find_by(id: transaction.contribution_id)

      if params["status"] == "SUCCESS"
        response_message = t('controllers.projects.contributions.orange_money_payment_confirmation.success')
      else
        response_message = t('controllers.projects.contributions.orange_money_payment_initialization.error', status: params["status"])
      end

      @contribution.response_code = params["status"]
      @contribution.transaction_number = params["txnid"]
      @contribution.response_message = response_message
      @contribution.payment_method = "Orange Money"
      @contribution.state_event = params["status"] == "SUCCESS" ? :confirm : :cancel
      @contribution.save!
      @contribution.notify_owner(:orange_money_payment_confirmed) if params["status"] == "SUCCESS"

    #  puts "IF REDIRECTION REDIRECTION REDIRECTION REDIRECTION REDIRECTION REDIRECTION "
    #  puts "IF REDIRECTION REDIRECTION REDIRECTION REDIRECTION REDIRECTION REDIRECTION "
#
    #  redirect_to project_contribution_path(project_id: @contribution.project.permalink, id: @contribution.id)
   # else
    #  puts "ELSE REDIRECTION REDIRECTION REDIRECTION REDIRECTION REDIRECTION REDIRECTION "
   #   puts "ELSE REDIRECTION REDIRECTION REDIRECTION REDIRECTION REDIRECTION REDIRECTION "
#
    #  redirect_to edit_project_contribution_path(@contribution.project.permalink, @contribution)
    end

    render json: { success: true }
  end


  def touch_payment_new
    @contribution = resource
    authorize @contribution

    @project = @contribution.project

    @html_operators = ''
    @operators = TouchService::LIST_OPERATORS
    @operators.each do |country, operators|
      @html_operators += '<optgroup label="' + country + '">'
      operators.each do |key, operator|
        @html_operators += '<option value="' + key + '">' + operator + '</option>'
      end
      @html_operators += '</optgroup>'
    end
  end


  def touch_payment_initialization
    @contribution = Contribution.find_by!(id: touch_params[:id])
    authorize @contribution

    @project = @contribution.project

    country_operator = touch_params[:country_operator].split('_')
    country = country_operator[0]
    operator = country_operator[1]
    phone = touch_params[:phone]
    @new_payment = false

    payment = TouchService.new country, operator, phone, @contribution
    @response = payment.initiate_paiement

    @response.merge!({
      "country_operator" => touch_params[:country_operator]
    })

    puts "======================== response #{@response} ========================"

    if @response['status'] == 'INITIATED'
      flash.now[:notice] = 'Valider le paiement sur votre téléphone'
      render 'projects/contributions/touch_payment_initialization'
    else
      @response['message'] ||= @response['detailMessage']
      @response['message'] ||= @response['description']
      @response['status'] ||= @response['code']
      redirect_to touch_payment_new_project_contribution_path(@contribution.project, @contribution), notice: "Code: #{@response['status']} #{@response['message']}"
    end
  end


  def touch_payment_status
    @contribution = Contribution.find_by!(id: touch_params[:id])
    authorize @contribution

    @project = @contribution.project

    country_operator = touch_params[:country_operator].split('_')
    country = country_operator[0]
    operator = country_operator[1]
    id_client = touch_params[:id_client]
    commit = touch_params[:commit]
    @new_payment = false

    if commit == 'Terminer le paiement'
      @new_payment = true

      payment = TouchService.new country, operator
      @response = payment.check_status id_client

      @response.merge!({
        "country_operator" => touch_params[:country_operator],
        "idFromClient" => id_client
      })

      puts "======================== response #{@response} ========================"

      if @response['status'] == 'PENDING'
        flash.now[:notice] = 'Valider le paiement sur votre téléphone'
        render 'projects/contributions/touch_payment_initialization'
      else
        if @response['status'] == 'SUCCESSFUL'
          response_message = t('controllers.projects.contributions.paypal_payment_confirmation.success')
    
          @contribution.response_code = @response['status']
          @contribution.payment_id = @response['idFromClient']
          @contribution.response_message = response_message
          @contribution.payment_method = "Touch"
          @contribution.state_event = :confirm
          @contribution.save!
    
          flash.notice = response_message
    
          redirect_to project_contribution_path(project_id: @contribution.project, id: @contribution.id)
        else
          response_message = t('controllers.projects.contributions.paypal_payment_confirmation.error', status: paypal_params[:payment_status])
    
          @contribution.response_code = @response['status']
          @contribution.payment_id = @response['idFromClient']
          @contribution.response_message = response_message
          @contribution.payment_method = "Touch"
          @contribution.state_event = :cancel
          @contribution.save!
    
          flash.alert = response_message
    
          redirect_to edit_project_contribution_path(project_id: @contribution.project, id: @contribution.id)
        end
      end
    else
      redirect_to touch_payment_new_project_contribution_path(@contribution.project, @contribution)
    end
  end


  def touch_payment_return
    @contribution = Contribution.find_by!(id: touch_params[:id])

    @project = @contribution.project
  end


  def pay_plus_africa_payment_confirmation
    transaction = PayPlusAfricaTransaction.find_by!(notif_token: params["token"])
    @contribution = Contribution.find_by!(id: transaction.contribution_id)
    response_status = PayPlusAfricaService.confirm_payment_for(@contribution, transaction)

    if response_status["response_code"] == "00"
      transaction.update_column(:invoice_number, response_status["token"])

      response_message = t('controllers.projects.contributions.pay_plus_africa_payment_confirmation.success')

      @contribution.response_code = response_status["status"]
      @contribution.transaction_number = response_status["token"]
      @contribution.response_message = response_message
      @contribution.payment_method = "Pay Plus Africa"
      @contribution.state_event = response_status["status"] == "completed" ? :confirm : :cancel
      @contribution.save!
      # @contribution.notify_owner(:pay_plus_africa_payment_confirmed) if response_status["status"] == "completed"

      flash.notice = response_message

      puts "IF REDIRECTION REDIRECTION REDIRECTION REDIRECTION REDIRECTION REDIRECTION "
      puts "IF REDIRECTION REDIRECTION REDIRECTION REDIRECTION REDIRECTION REDIRECTION "

      redirect_to project_contribution_path(project_id: @contribution.project.permalink, id: @contribution.id)
    else
      puts "ELSE REDIRECTION REDIRECTION REDIRECTION REDIRECTION REDIRECTION REDIRECTION "
      puts "ELSE REDIRECTION REDIRECTION REDIRECTION REDIRECTION REDIRECTION REDIRECTION "

      response_message = t('controllers.projects.contributions.pay_plus_africa_payment_confirmation.error', status: params["status"])
      flash.alert = response_message

      redirect_to edit_project_contribution_path(@contribution.project.permalink, @contribution)
    end


    # render json: { success: true }
  end

  def vpc_payment
    @project      = parent
    @contribution = resource
    authorize @contribution
    payment = register_with_migs_virtual_payment_client_service
    if payment.is_authorized?
      @contribution.assign_attributes(payment.info_hash.merge({ payment_method: "MasterCard Internet Gateway Service (MIGS)" }))
      @contribution.notify_owner(:payment_confirmed)
      @contribution.state_event = :confirm
      @contribution.save
      flash.notice = t('controllers.projects.contributions.vpc_payment.success', amount: payment.amount)
      redirect_to project_contribution_path(@project, @contribution)
    else
      @contribution.notify_owner(payment.template_symbol)
      @contribution.state_event = :cancel
      @contribution.save
      flash.alert = t('controllers.projects.contributions.vpc_payment.error', error: payment.response_message)
      redirect_to edit_project_contribution_path(@project, @contribution)
    end
  end


  def mobile_money_payment_initiation
    @project      = parent
    @contribution = resource
    authorize @contribution
    oltranz_response = MobileMoneyPaymentsService.new(
      payingaccountidatsp: "250" + params[:mobile_money_payment_form][:payingaccountidatsp].last(9),
      paymentspid_name: nil # we'll replace this with the provider name in case the automatic provider detection fails
    ).initiate_payment_request_for(@contribution)


    if oltranz_response.nil?
      flash.alert = t('controllers.projects.contributions.mobile_money_payment_initiation.invalid_phone')
      redirect_to edit_project_contribution_path(@project, @contribution)
    else
      oltranz_response = Hash.from_xml(oltranz_response.body)["COMMAND"]
      if oltranz_response["RESPONDERSTATUS"] == "100"
        success_message = t('controllers.projects.contributions.mobile_money_payment_initiation.success')
        @contribution.update(
          response_code: oltranz_response["RESPONDERSTATUS"],
          transaction_number: oltranz_response["TRANSID"],
          response_message: success_message,
          payment_method: "Mobile Money"
        )
        flash.notice = success_message
        redirect_to edit_project_contribution_path(@contribution.project, @contribution)
      else
        error_message = t('controllers.projects.contributions.mobile_money_payment_initiation.error',
          error_code: oltranz_response['REQUESTSTATUS'],
          error_message: oltranz_response['REQUESTSTATUSDESC']
        )
        @contribution.update(
          response_code: oltranz_response["RESPONDERSTATUS"],
          transaction_number: oltranz_response["TRANSID"],
          response_message: error_message,
          payment_method: "Mobile Money"
        )
        @contribution.state_event = :cancel
        @contribution.save
        flash.alert = error_message
        redirect_to edit_project_contribution_path(@contribution.project, @contribution)
      end
    end
  end

  def mobile_money_payment_confirmation
    oltranz_request = Hash.from_xml(request.body.read)["COMMAND"]
    @contribution = Contribution.find(oltranz_request["TRANSID"].last(8).to_i)
    # oltranz_request
    # => {"TRANSID"=>"9000000059", "CONTRACTID"=>"421001", "STATUSCODE"=>"100", "SPTRANSID"=>"818207", "STATUSDESC"=>"Success"}
    if oltranz_request["STATUSCODE"] == "100" &&
      @contribution.update(
        response_code: "100",
        transaction_number: oltranz_request["TRANSID"],
        response_message: t('controllers.projects.contributions.mobile_money_payment_confirmation.success'),
        payment_method: "Mobile Money"
      )
      @contribution.state_event = :confirm
      @contribution.notify_owner(:mobile_money_payment_confirmed)
      @contribution.save!
      render xml: "<COMMAND><RESPONDERSTATUS>100</RESPONDERSTATUS><REQUESTSTATUS>301</REQUESTSTATUS><REQUESTSTATUSDESC>Pending</REQUESTSTATUSDESC></COMMAND>", layout: false

    else
      error_message = t('controllers.projects.contributions.mobile_money_payment_initiation.error',
        error_code: oltranz_request['STATUSCODE'],
        error_message: oltranz_request['STATUSDESC']
      )
      @contribution.update(
        response_code: oltranz_request["STATUSCODE"],
        transaction_number: oltranz_request["TRANSID"],
        response_message: error_message,
        payment_method: "Mobile Money"
      )
      @contribution.state_event = :cancel
      @contribution.save
      render xml: "<COMMAND><RESPONDERSTATUS>999</RESPONDERSTATUS><REQUESTSTATUS>999</REQUESTSTATUS><REQUESTSTATUSDESC>Error: Transaction expired or refused by Oltranz/SP</REQUESTSTATUSDESC></COMMAND>", layout: false

    end
  end

  def check_mobile_money_payment_success
    @contribution = Contribution.find(params[:contribution_id])
    authorize(@contribution)
    
    # render json: @contribution.state

    if @contribution.state == "confirmed"
      redirect_to project_contribution_path(project_id: @contribution.project.permalink, id: @contribution.id)
    else
      redirect_to edit_project_contribution_path(project_id: @contribution.project.permalink, id: @contribution.id)
    end
  end


  protected

  def touch_params
    params.permit(:id, :phone, :country_operator, :id_client, :commit)
  end

  def permitted_params
    params.permit(policy(@contribution || ContributionForm).permitted_attributes)
  end

  def collection
    @contributions ||= apply_scopes(parent.contributions).available_to_display.where(matching_id: nil).order("confirmed_at DESC").per(10)
  end

  def empty_reward
    Reward.new(minimum_value: 0, description: t('controllers.projects.contributions.new.no_reward'))
  end

  def parent
    @parent ||= Project.find_by_permalink!(params[:project_id])
  end

  def resource
    @resource ||= parent.contributions.find(params[:id])
  end

  private

  def has_mangopay_prerequisites
    if user_signed_in?
      if current_user.light_authentication_ready?
        return true
      else
        flash.alert = t('projects.contributions.new.not_mangopay_ready')
        redirect_to edit_user_path(current_user, redirect_url: new_project_contribution_path(parent.permalink)) and return false
      end
    else
      # redirect_to new_user_session_path
      redirect_to new_user_registration_path
    end
  end


  def register_with_migs_virtual_payment_client_service
    MigsVirtualPaymentClientService.new(params)
  end

end
