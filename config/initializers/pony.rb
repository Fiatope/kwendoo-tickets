Pony.options = {
  #:to => 'contact@tickets.kwendoo.rw',
  :via => :smtp,
  :via_options => {
    :address => Configuration[:SENDGRID_ADDRESS],
    :port => Configuration[:SENDGRID_PORT],
    :authentication => :plain,
    :user_name => Configuration[:SENDGRID_USERNAME],
    :password => Configuration[:SENDGRID_PASSWORD],
    :enable_starttls_auto => false,
    :domain => "tickets.kwendoo.com" # the HELO domain provided by the client to the server
  }
}



