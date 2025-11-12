class PromotionPolicy < ApplicationPolicy

  def new?
    true
  end

  def create?
    done_by_owner_or_admin? && record.project.online?
  end

  def update?
    done_by_owner_or_admin?
  end

  def permitted_attributes
    {promotion: record.attribute_names.map(&:to_sym) + [reward: []]}
  end
end
