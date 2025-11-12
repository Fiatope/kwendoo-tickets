class Invitation
  extend ActiveModel::Naming  
  include ActiveModel::Conversion    
  include ActiveModel::Validations
  include ActionView::Helpers::TextHelper

  attr_accessor :name, :email, :subject, :message, :type, :link, :recipients    
   
  validates :name,
            :presence => true
 
  validates :email,
            :format => { :with => /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/ }

  validates :subject,
            :presence => true  

  validates :link,
            :presence => true

  validates :recipients,
            :format => { :with => /(\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})(,\s*([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,}))*\z)/i }

  validates :message,
            :length => { :minimum => 4, :maximum => 1000 }

  def initialize(attributes = {})    
    attributes.each do |name, value|      
     send("#{name}=", value)    
    end  
  end    

  def deliver    
    return false unless valid?
    Pony.mail({
      :from => %("#{name}" <#{email}>),
      :to => recipients, 
      :reply_to => email,
      :subject => subject,
      :body => message,
      :html_body => simple_format(message)
    })

  end        

  def persisted?    
   false  
  end
end 

