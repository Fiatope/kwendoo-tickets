class MessagesController < ApplicationController
   def new
    @message = Message.new
   end
   

   def create
    @message = Message.new(params[:message])
    if @message.deliver 
       render :thank_you_fund  
    else
       render :new
    end
   end

end
