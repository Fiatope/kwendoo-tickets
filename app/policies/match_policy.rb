class MatchPolicy < ApplicationPolicy
  def create?
    record.project.online?
  end

  def update?
    record.user == user && record.project.online?
  end
  
  def vpc_payment?
    update?
  end

  def show?
    record.user == user
  end
end
