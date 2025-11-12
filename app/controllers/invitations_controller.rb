class InvitationsController < ApplicationController
  def new
    @invitation = Invitation.new
  end
   

  def create
    @invitation = Invitation.new(params[:invitation])
    if @invitation.deliver
      if project = Project.find_by(permalink: @invitation.link.split("/").last)
        flash.notice = t('controllers.invitations.create.success')
        redirect_to project
      else
        render :confirmation_envoi
      end
    else
      render :new
    end
  end

end
