# coding: utf-8
class UsersController < ApplicationController
  before_action :has_mangopay_prerequisites, only: [:payments, :update_bank_information, :mangopay_authentications, :mangopay_upload_kyc_files]
  after_action :verify_authorized, except: :show

  inherit_resources
  actions :show, :edit, :update
  respond_to :html, :json

  def show
    return redirect_to root_url(subdomain: resource.channel.permalink, protocol: :http) if resource.channel? && resource.channel.present?
    show!{
      @projects = Project.contributed_by(@user).
        includes(:category, :contributions, :project_total)
      set_facebook_url_admin(@user)
      @title = "#{@user.display_name}"
    }
  end

  def edit
    authorize resource
    @user.build_organization unless @user.organization
    render :profile if request.xhr?
  end

  def credits
    authorize resource
    @title = "Credits: #{@user.display_name}"
    @credits = @user.contributions.can_refund
  end

  def pay
    authorize resource
  end

  def payments
    authorize resource
    @bank_information = @user.bank_information || @user.build_bank_information
  end

  def mangopay_authentications
    authorize resource
    @user = current_user
    @kycs = @user.kycs_updatable_elements
  end

  def mangopay_upload_kyc_files
    authorize resource

    update! do |success, failure|
      success.html do
        flash.notice = update_success_flash_message unless params[:investment_prospect]
        return redirect_to settings_user_path(@user) if params[:settings]
        if params[:investment_prospect]
          flash.delete(:notice)
          return redirect_to root_path
        end
        return redirect_to mangopay_authentications_user_path(@user)
      end
      failure.html do
        flash.alert = @user.errors.full_messages.to_sentence
        return redirect_to settings_user_path(@user) if params[:settings]
        @user.build_organization unless @user.organization
        return render 'edit'
      end
      success.json do
        @user.reload
        return render json: { status: :success, uploaded_image: @user.uploaded_image_url(:thumb_avatar), :"organization_attributes[image]" => (@user.organization.image_url(:thumb) rescue nil ) }
      end
      failure.json do
        return render json: { status: :error }
      end
    end
  end

  def settings
    authorize resource
    @title = "Settings: #{@user.display_name}"
    @subscribed_to_updates = @user.updates_subscription
    @unsubscribes = @user.project_unsubscribes
  end

  def set_email
    authorize current_user || User.new
    @user = current_user
    render layout: 'devise'
  end

  def update_email
    authorize resource
    update! do |success, failure|
      success.html do
        flash.notice = t('devise.confirmations.send_instructions')
        sign_out current_user
        redirect_to root_path
      end
      failure.html do
        flash.notice = @user.errors[:email].to_sentence if @user.errors[:email].present?
        return render :set_email, layout: 'devise'
      end
    end
  end

  def update
    authorize resource
    update! do |success, failure|
      success.html do

        flash.notice = update_success_flash_message unless params[:investment_prospect]
        return redirect_to settings_user_path(@user) if params[:settings]

        if params[:investment_prospect]
          flash.delete(:notice)
          return redirect_to root_path
        end

        if params[:next_url].present?
          return redirect_to params[:next_url] || edit_user_path(@user)
        else
          return redirect_to params[:redirect_url] || edit_user_path(@user)
        end
      end
      failure.html do
        flash.alert = @user.errors.full_messages.to_sentence
        return redirect_to settings_user_path(@user) if params[:settings]
        @user.build_organization unless @user.organization
        return render 'edit'
      end
      success.json do
        return render json: { status: :success, uploaded_image: @user.uploaded_image_url(:thumb_avatar), :"organization_attributes[image]" => (@user.organization.image_url(:thumb) rescue nil ) }
      end
      failure.json do
        return render json: { status: :error }
      end
    end
  end

  def update_password
    authorize resource
    if @user.update_with_password(permitted_params[:user])
      flash.notice = t('controllers.users.update.success')
    else
      flash.alert  = @user.errors.full_messages.to_sentence
    end
    return redirect_to settings_user_path(@user)
  end

  def update_bank_information
    authorize resource
    if @user.bank_information.blank?
      @bank_information = @user.build_bank_information(bank_informations_permitted_params)
    else
      @bank_information = @user.bank_information
      @bank_information.assign_attributes(bank_informations_permitted_params)
    end

    puts "BF BF BF BF BF BF BF BF BF BF BF BF BF BF BF BF BF BF "
    puts @bank_information.inspect
    puts "BF BF BF BF BF BF BF BF BF BF BF BF BF BF BF BF BF BF "

    begin
      if @bank_information.save!
        flash.notice = t('controllers.users.update.success')
        if params[:project]
          if @user.official_document.blank? || @user.official_document2.blank?
            return redirect_to mangopay_authentications_user_path(current_user, project: params[:project])
          else
            return redirect_to pay_project_path(Project.find_by_permalink(params[:project]))
          end
        end
        return (redirect_to (if @user.projects.to_a.select {|p| p.funds_can_be_withdrawn? }.any?
          pay_project_path(@user.projects.to_a.select {|p| p.funds_can_be_withdrawn? }.last)
        else 
          params[:redirect_url] || payments_user_path(@user)
        end))
      else
        flash.alert = @user.errors.full_messages.to_sentence
        redirect_back(fallback_location: root_path)
      end
    rescue Exception => e
      flash.alert = e.message
      redirect_back(fallback_location: root_path)
    end
  end

  protected

  def update_success_flash_message
    if (params['user']['email'] != @user.email rescue false) && params['user']['email'].present?
      t('devise.confirmations.send_instructions')
    else
      t('controllers.users.update.success')
    end
  end

  def permitted_params
    params.permit(policy(@user || User).permitted_attributes)
  end

  def bank_informations_permitted_params
    params.require(:bank_information).permit(:iban, :bic, :us_account_number,
      :us_account_aba, :ca_account_type, :ca_institution_number, :ca_account_number,
      :ca_branch_code, :ca_bank_name, :other_account_number, :other_bic, :other_country, :owner_address, :owner_city, :owner_region, :owner_postal_code)
  end

  def has_mangopay_prerequisites
    if user_signed_in?
      if current_user.light_authentication_ready?
        return true
      else
        flash.alert = t('controllers.projects.contributions.new.not_mangopay_ready')
        return redirect_to edit_user_path(current_user, redirect_url: params[:redirect_url])
      end
    else
      redirect_to new_user_session_path
    end
  end
end
