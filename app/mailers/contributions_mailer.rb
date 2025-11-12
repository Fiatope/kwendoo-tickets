class ContributionsMailer < ApplicationMailer
    default from: 'contact@kwendoo.com'

    def welcome_email(contribution)
        @user = @contribution
        @url = 'http://www.gmail.com'
        mail(to: "falliloudiaww@gmail.com", subject: 'Welcome to My Awesome Site')
    end

end
