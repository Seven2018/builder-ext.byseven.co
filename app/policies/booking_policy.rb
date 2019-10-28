class BookingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    check_access
  end

  def create?
    check_access
  end

  def transform?
    check_access_admin
  end

  def destroy?
    check_access
  end

  private

  def check_access_admin
    ['super admin', 'admin', 'training manager'].include? (user.access_level)
  end

  def check_access
    ['super admin', 'admin', 'training manager', 'HR'].include? (user.access_level)
  end
end
