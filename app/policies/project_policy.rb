class ProjectPolicy < ApplicationPolicy
  def create?
    done_by_owner_or_admin? || is_channel_admin?
  end

  def update?
    create?
  end

  def show?
    if record.draft? || record.soon?
      create?
    else
      true
    end
  end

  def ticketing_database?
    update?
  end

  def success?
    update?
  end

  def presuccess?
    update?
  end
 
  def pay?
    update? 
  end

  def reports?
    update?
  end

  def invitations?
    update?
  end

  def promotions?
    update?
  end

  def destroy?
    change_state? && record.can_push_to_trash?
  end

  def approve?
    change_state? && record.can_approve?
  end

  def launch?
    change_state? && record.can_launch?
  end

  def reject?
    change_state? && record.can_reject?
  end

  def push_to_draft?
    change_state? && record.can_push_to_draft?
  end

  def push_to_request_funds?
    change_state? && record.can_push_to_request_funds?
  end

  def push_to_fraud_suspiscion?
    change_state? && record.can_push_to_fraud_suspiscion?
  end

  def push_to_paid?
    change_state? && record.can_push_to_paid?
  end

  def permitted_attributes
    if user.present? && (!record.instance_of?(Project) || fully_editable?)
      {
        project: record.attribute_names.map(&:to_sym) +
                 [:location, :tag_list, :currency, :start_date, :is_prebooked, :sanitary_pass,
                  reward_categories_attributes: [ :id, :name, :_destroy, rewards_attributes: [ :id, :title, :maximum_contributions, :description, :minimum_value, :promote, :couple, :_destroy ] ]
                 ] -
                 [
                   :online_date, :created_at, :updated_at, :about_html,
                   :budget_html, :terms_html, :sent_to_analysis_at
                 ]
      }
    else
      {
        project: [:about,         :video_url,            :uploaded_image,
                  :hero_image,    :headline,             :budget,
                  :terms,         :address_neighborhood, :location,
                  :address_city,  :address_state,        :hash_tag,
                  :site, :tag_list, :start_date, :is_prebooked, :sanitary_pass,
                  reward_categories_attributes: [ :id, :name, :_destroy, rewards_attributes: [ :id, :title, :maximum_contributions, :description, :minimum_value, :promote, :couple, :_destroy ] ]
                ]
      }


    end
  end

  protected

  def change_state?
    user.present? && (user.admin? || is_channel_admin?)
  end

  def fully_editable?
    record.instance_of?(Project) && ( !record.persisted? ||
                                      user.admin? || 
                                      done_by_owner_or_admin? ||  
                                      (record.draft? ||
                                       record.rejected? ||
                                       record.soon?) )
  end

  def is_channel_admin?
    user.present? && ( record.last_channel.try(:user) == user ||
                       user.channels.include?(record.last_channel) )
  end

  class Scope < Struct.new(:user, :scope)
    def resolve
      if user.admin?
        scope
      else
        from_managed_channels = scope.joins(channels: :members).
          where(channel_members: { user_id: user.id })
        from_managed_directly = scope.where(user_id: user.id)
        scope.from("(#{from_managed_channels.to_sql} UNION #{from_managed_directly.to_sql}) as projects")
      end
    end
  end
end
