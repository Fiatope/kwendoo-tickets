class NotificationsMailer < ActionMailer::Base
  layout 'email'
  default from: 'contact@kwendoo.com'

  def notify(notification)
    @notification = notification
    address = Mail::Address.new @notification.origin_email
    address.display_name = @notification.origin_name
    subject = render_to_string(template: "notifications_mailer/subjects/#{@notification.template_name}.#{@notification.locale}")
    attachments['CGU_Kwendoo_vf.pdf'] = File.read('./app/assets/images/CGU_Kwendoo_vf.pdf') if @notification.template_name == 'Validation de votre inscription'

    if @notification.template_name == 'payment_confirmed' || @notification.template_name == 'booking_confirmed'
      @contribution = @notification.contribution
      @project = @contribution.project
        I18n.with_locale(@notification.locale) do
          attachments['KwendooReceipt.pdf'] = WickedPdf.new.pdf_from_string(
            render_to_string(
              pdf: "#{@project.permalink}_tickets",
              disposition: "inline",
              template: "projects/contributions/tickets_index.pdf.slim"
            )
          )
        end
    end

    params = {
      from: address.format,
      to: @notification.user.email,
      subject: subject,
      template_name: @notification.template_name
    }

    muted_templates = ['new_user_registration', 'project_visible', 'project_paid', 'project_owner_contribution_confirmed', 'project_owner_contribution_canceled']

    if (@notification.bcc.present? || ENV['EMAIL_PAYMENTS'].present?) &&
      !(muted_templates.include?(@notification.template_name))

      params.merge!({ bcc: @notification.bcc || ENV['EMAIL_PAYMENTS'] })
    end

    m = nil
    I18n.with_locale(@notification.locale) do
      m = mail(params)
    end
    m
  end

  def project_successfuly_created
    @project = params[:project]
    mail(to: @project.user.email, subject: 'Évenement crée avec succès')
  end

  def payment_confirmed
    @contribution = params[:contribution]
    mail(to: @contribution.user.email, subject: "Confirmation paiement.")
  end
end
