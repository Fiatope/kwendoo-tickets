class Users::QuestionsController < ApplicationController
  inherit_resources
  belongs_to :user

  def new
    @project = Project.find(params[:project_id])

    unless current_user
      session[:return_to] = project_path(@project, anchor: 'open-new-user-question-modal')
      return redirect_to new_user_session_path
    end
    @user = parent
    render layout: false
  end

  def create
    project = Project.find(params[:project_id])
    unless current_user
      session[:return_to] = project_path(project, anchor: 'open-new-user-question-modal')
      return redirect_to new_user_session_path
    end

    begin
      Users::QuestionsMailer.new(params[:question][:body], parent, project, current_user).deliver
    rescue => e
      Rails.logger.warn "[Mailer] Failed to send question email: #{e.class} #{e.message}"
    end
    flash.notice = "#{parent.display_name} a reçu votre question et va vous contacter."
    redirect_to project_path(project)
  end
end
