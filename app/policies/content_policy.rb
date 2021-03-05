class ContentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    check_access
  end

  def show?
    check_access
  end

  def update?
    check_access
  end

  def destroy?
    check_access_seven
  end

  private

  def check_access_seven
    ['super admin', 'admin', 'training manager'].include? user.access_level
  end

  def check_access
    ['super admin', 'admin', 'training manager', 'sevener+'].include? user.access_level
  end
end
