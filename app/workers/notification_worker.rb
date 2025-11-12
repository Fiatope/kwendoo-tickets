class NotificationWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5

  def perform(notification_id)
    notification = Notification.find(notification_id)

    NotificationsMailer.notify(notification).deliver
    notification.update_attribute(:dismissed, true)

    if notification.template_name == "mobile_money_payment_confirmed"
      MobileMoneyPaymentsService.new({}).send_final_confirmation_request(notification.contribution)
    end
  end
end
