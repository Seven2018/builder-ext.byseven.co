class ContentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    ['super admin', 'admin', 'training manager', 'sevener+'].include? user.access_level
  end

  def show?
    ['super admin', 'admin', 'training manager', 'sevener+'].include? user.access_level
  end

  def update?
    ['super admin', 'admin', 'training manager', 'sevener+'].include? user.access_level
  end

  def destroy?
    check_access
  end

  private

  def check_access
    ['super admin', 'admin', 'training manager'].include? user.access_level
  end
end
