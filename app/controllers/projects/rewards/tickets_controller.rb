class Projects::Rewards::TicketsController < ApplicationController
  include Neighborly::Admin

  inherit_resources
  defaults :resource_class => Reward

  before_action except: [:free_ticket, :free_ticket_index] do
    authorize Neighborly::Admin, :access?
  end

  def free_ticket
    @reward = Reward.find(params[:id])
  end

  def free_ticket_index
    @reward = Reward.find(params[:id])

    if free_ticket_params.permitted?
      permitted_free_tickets = free_ticket_params[:free_tickets].to_unsafe_h
      @tickets = []
      permitted_free_tickets[:name].each_with_index do |name, i|
        free_ticket = {
          name: name,
          email: permitted_free_tickets[:email][i]
        }
        @ticket = Ticket.find_or_create_by(free_ticket.merge!({ reward_id: @reward.id }))
        @tickets << @ticket

        TicketWorker.perform_async(@ticket.id) if @ticket.present?
      end

      respond_to do |format|
        format.html
        format.pdf do
          render :pdf => "#{@reward.reward_category.project.permalink}_tickets",
            :disposition => "inline",
            :template => "projects/rewards/tickets/tickets_index.pdf.slim"
        end
      end
    else
      redirect_to main_app.free_ticket_path(@reward), alert: I18n.t('controllers.users.invalid_information')
    end
  end

  protected

  def free_ticket_params
    params.permit(free_tickets: [{ name: [] }, { email: [] }])
  end

  def collection
    @tickets = apply_scopes(end_of_association_chain).list_of_tickets.order('rewards.id desc').page(params[:page]) || []
  end
end
