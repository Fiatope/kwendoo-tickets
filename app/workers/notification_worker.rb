class NotificationWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5

  def perform(notification_id)
    notification = Notification.find(notification_id)

    begin
      NotificationsMailer.notify(notification).deliver
    rescue => e
      Rails.logger.error "[NotificationWorker] Email delivery failed for notification ##{notification_id}: #{e.message}"
      raise e # Let Sidekiq retry handle it
    end
    notification.update_attribute(:dismissed, true)

    if notification.template_name == "mobile_money_payment_confirmed"
      MobileMoneyPaymentsService.new({}).send_final_confirmation_request(notification.contribution)
    end
  end
end
