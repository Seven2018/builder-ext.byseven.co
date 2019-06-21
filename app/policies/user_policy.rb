class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    user.access_level == "super admin"
  end

  def show?
    true
    # ['super admin', 'admin', 'training manager'].include? user.access_level
  end

  def edit?
    user.access_level == "super admin"
  end

  def update?
    user.access_level == "super admin"
  end

  def destroy?
    user.access_level == "super admin"
  end
end
