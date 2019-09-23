class ProjetOwnershipPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    check_access
  end

  def destroy?
    check_access
  end

  def check_access
    ['super admin', 'admin', 'training manager'].include? user.access_level
  end
end
