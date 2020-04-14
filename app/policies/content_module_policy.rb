class ContentModulePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    check_access_sevener
  end

  def show?
    check_access_sevener
  end

  def edit?
    check_access_sevener
  end

  def update?
    check_access_sevener
  end

  def destroy?
    check_access_sevener
  end

  def move_up?
    check_access_sevener
  end

  def move_down?
    check_access_sevener
  end

  def save?
    check_access
  end

  private

  def check_access
    ['super admin', 'admin', 'training manager'].include? user.access_level
  end

  def check_access_sevener
    ['super admin', 'admin', 'training manager', 'sevener+'].include? user.access_level
  end
end
