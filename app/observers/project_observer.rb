class ProjectObserver < ActiveRecord::Observer
    
    
  def after_save(project)
    build_project_total(project)

    if project.video_url.present? && project.video_url_changed?
      ProjectDownloaderWorker.perform_async(project.id)
    end
  end

  def after_create(project)
    deliver_default_notification_for(project, :project_visible)
    notify_new_draft_project(project)
    project.update({ online_date: DateTime.now })
  end

  def from_online_to_waiting_funds(project)
    project.notify_owner( :project_in_wainting_funds)
    deliver_default_notification_for(project, :project_in_wainting_funds)
  end

  def from_waiting_funds_to_successful(project)
    if project.goal? && !project.goal
      project.notify_owner( :project_success)
      deliver_default_notification_for(project, :project_success)
    end

    notify_admin_that_project_reached_deadline(project)
  end

  def notify_admin_that_project_reached_deadline(project)
    if (user = User.where(email: ::Configuration[:email_payments]).first)
      Notification.notify_once(
        :adm_project_deadline,
        user,
        {project_id: project.id},
        project: project,
        origin_email: Configuration[:email_system]
      )
    end
  end

  def from_draft_to_rejected(project)
    deliver_default_notification_for(project, :project_rejected)
  end

  def from_draft_to_online(project)
    deliver_default_notification_for(project, :project_visible)
    project.update({ online_date: DateTime.now })
  end


  def from_online_to_fraud_suspiscion(project)
      
      
               
    project.notify_owner( :project_fraud_suspiscion)
    deliver_default_notification_for(project, :project_fraud_suspiscion)
  end

  def from_waiting_funds_to_fraud_suspiscion(project)
    project.notify_owner( :project_fraud_suspiscion)
    deliver_default_notification_for(project, :project_fraud_suspiscion)
  end

  def from_online_to_request_funds(project)
    #project.notify_owner( :project_refund_request)
    deliver_default_notification_for(project, :project_refund_request)
  end

  
  def from_waiting_funds_to_request_funds(project)
    project.notify_owner( :project_refund_request)
    deliver_default_notification_for(project, :project_refund_request)
  end
 

  def from_successful_to_request_funds(project)
    project.notify_owner( :project_refund_request)
    deliver_default_notification_for(project, :project_refund_request)
  end

   def from_failed_to_request_funds(project)
    project.notify_owner( :project_refund_request)
    deliver_default_notification_for(project, :project_refund_request)
  end

   def from_request_funds_to_paid(project)
    project.notify_contributors( :project_paid)
    deliver_default_notification_for(project, :project_paid)
   end  

  def from_draft_to_soon(project)
    #project.notify_owner(:project_approved)
    deliver_default_notification_for(project, :project_approved)
  end

  def from_soon_to_online(project)
    from_draft_to_online(project)
  end

  def from_online_to_failed(project)
    notify_users(project)

    project.contributions.with_state('waiting_confirmation').each do |contribution|
      contribution.notify_owner(:pending_contribution_project_unsuccessful,
                                { },
                                project: project)
    end

    project.notify_owner(:project_unsuccessful, user_id: project.user.id)
  end

  def from_waiting_funds_to_failed(project)
    from_online_to_failed(project)
    notify_admin_that_project_reached_deadline(project)
  end

  private

  def notify_new_draft_project(project)
    if (user = project.new_draft_recipient)
      Notification.notify_once(
        project.notification_type(:new_draft_project),
        user,
        {project_id: project.id, channel_id: project.last_channel.try(:id)},
        {
          project: project,
          channel: project.last_channel,
          origin_email: project.user.email,
          origin_name: project.user.display_name
        }
      )
    end
  end

  def notify_users(project)
    puts "FFFFFFFFFFFFFFFFFFFFFFF"
    puts "FFFFFFFFFFFFFFFFFFFFFFF"

    project.contributions.with_state('confirmed').each do |contribution|
      unless contribution.notified_finish
        contribution.notify_owner((project.successful? ? :contribution_project_successful : :contribution_project_unsuccessful),
                                  { },
                                  { project: project })

        contribution.update({ notified_finish: true })
      end
    end
  end

  def deliver_default_notification_for(project, notification_type)
    project.notify_owner(
      project.notification_type(notification_type),
      { channel_id: project.last_channel.try(:id) },
      {
        channel: project.last_channel,
        origin_email: project.last_channel.try(:user).try(:email) || Configuration[:email_contact],
        origin_name: project.last_channel.try(:name) || Configuration[:company_name]
      }
    )
  end

  def build_project_total(project)
    ProjectTotalBuilder.new(project).perform
  end
end
