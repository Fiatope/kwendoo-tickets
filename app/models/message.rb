class Message  
  extend ActiveModel::Naming  
  include ActiveModel::Conversion    
  include ActiveModel::Validations
  include ActionView::Helpers::TextHelper

  attr_accessor :name, :email, :subject, :message, :type    
   
  validates :name,
            :presence => true
 
  validates :subject,
            :presence => true  

  validates :email,
            :format => { :with => /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/ }

  validates :message,
            :length => { :minimum => 4, :maximum => 1000 }

  def initialize(attributes = {})    
    attributes.each do |name, value|      
     send("#{name}=", value)    
    end  
  end    

  def deliver    
    return false unless valid?

    # Pony.mail({
    #   :from => %("#{name}" <#{email}>),
    #   :to => "contact@kwendoo.rw", 
    #   :reply_to => email,
    #   :subject => subject,
    #   :body => message,
    #   :html_body => simple_format(message)
    # })

    Pony.mail({
      :from => %("#{name}" <#{'contact@fiatope.com'}>),
      :to => email,
      :subject => subject,
      :body => message,
      :html_body => simple_format(message),
      :via => :smtp,
      :via_options => {
        :address              => Configuration[:sendgrid_address],
        :port                 => Configuration[:sendgrid_port],
        :enable_starttls_auto => Configuration[:sendgrid_tls].downcase == 'true' ? true : false,
        :user_name            => Configuration[:sendgrid_username],
        :password             => Configuration[:sendgrid_password],
        :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
        :domain               => "fiatope.com", # the HELO domain provided by the client to the server
        :arguments => ''
      }
    })

  end        

  def persisted?    
   false  
  end
end 

