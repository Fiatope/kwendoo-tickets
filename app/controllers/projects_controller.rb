# coding: utf-8
class ProjectsController < ApplicationController
  after_action :verify_authorized, except: [:index, :video, :video_embed, :embed,
                                            :embed_panel, :comments, :budget,
                                            :reward_contact, :send_reward_email,
                                            :start]

  before_action :has_mangopay_prerequisites, only: [:new, :create]

  respond_to :html, :csv

  def new
    @project = Project.new(user: current_user)
    @project.reward_categories.build
    authorize @project
  end

  def event_date
    start_date
  end

  def ticketing_database
    authorize resource

    tickets = TicketsForProject.new(resource)

    respond_to do |format|
      format.csv do
        send_data tickets.to_csv, filename: "tickets-#{Date.today}.csv"
      end
    end
  end

  def online_event
    online_days = (event_date - online_date).to_i
  end

  def index
    projects_vars = {
      coming_soon: :soon,
      ending_soon: :expiring,
      featured:    :featured,
      recommended: :recommends,
      successful:  :successful
    }

    projects_vars.each do |var_name, scope|
      instance_variable_set "@#{var_name}", ProjectsForHome.send(scope)
    end

    @featured = Project.featured.last(3)
    @successful = @successful.take(2) if browser.device.mobile?
    @channels = Channel.with_state('online').order('RANDOM()').limit(4)
    @press_assets = PressAsset.order('created_at DESC').limit(5)
  end

  def create
    @project = Project.new(permitted_params[:project].merge(user: current_user)) # , currency: params[:currency]
    @project.address_state = @project.country.capitalize
    authorize @project
    @project.save!

    NotificationsMailer.with(project: @project).project_successfuly_created.deliver_now

    respond_with @project, location: success_project_path(@project)
  end

  def success
    authorize resource
  end

  def presuccess
    authorize resource
  end

  def edit
    authorize resource
    respond_with resource
  end

  def update
    authorize resource

    respond_with Project.update(resource.id, permitted_params[:project].merge!(address_state: resource.country.capitalize)),
      location: project_path(@project)
  end

  def show
    authorize resource
    set_facebook_url_admin(resource.user)
    if current_user.present? && current_user
      @user_contributions = current_user.contributions
      @pending_contributions = []
      @user_contributions.each do |c|
        if c.state == "waiting_confirmation"
          @pending_contributions << c
        end
      end
      sum = 0
      @pending_contributions.each {|c| sum += c.value_in_rwf.to_i }
      if @pending_contributions.count > 1
        flash.notice = "Your #{@pending_contributions.count} payments totaling #{sum}EUR are currently being processed. We'll send you an email as soon as they are confirmed."
      elsif @pending_contributions.count == 1
        flash.notice = "Your contribution of #{sum} EUR is currently being processed. We'll send you an email as soon as it is confirmed."
      end
    end
    if @project.id == 25
      @bg_sm = "bg-small"
    end
    render :about if request.xhr?
  end

  def comments
    @project = resource
  end

  def pay
    authorize resource
  end

  def reports
    authorize resource
    @tickets = @project.rewards.list_of_tickets.order('rewards.id desc').page(params[:page]) || []
  end

  def invitations
    authorize resource
    @tickets = @project.rewards.list_of_tickets.order('rewards.id desc').page(params[:page]) || []
  end

  def promotions
    authorize resource
    @promotions = @project.promotions
  end

  def budget
    @project = resource
  end

  %w(embed video_embed).each do |method_name|
    define_method method_name do
      @title = resource.name
      render layout: 'embed'
    end
  end

  def embed_panel
    @project = resource
    render layout: !request.xhr?
  end

  def start
    @projects = ProjectsForHome.successful[0..3]
    @channel  = channel.decorate if channel
  end

  private

  def permitted_params
    params.permit(policy(@project || Project).permitted_attributes)
  end

  def resource
    @project ||= Project.find_by_permalink!(params[:id])
  end

  def has_mangopay_prerequisites
    if user_signed_in?
      if current_user.light_authentication_ready?
        return true
      else
        flash.alert = t('projects.new.not_mangopay_ready')
        redirect_to edit_user_path(current_user, redirect_url: new_project_path) and return false
      end
    else
      redirect_to new_user_session_path
    end
  end
end


  def exp
    online_days && (event_date - online_date).to_i

  end
