class WorkshopModulePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    check_access
  end

  def show?
    true
  end

  def update?
    true
  end

  def destroy?
    check_access
  end

  def move_up?
    check_access
  end

  def move_down?
    check_access
  end

  def save?
    check_access
  end

  def viewer?
    true
  end

  def copy_form?
    check_access
  end

  def copy?
    check_access
  end

  private

  def check_access
    ['super admin', 'admin', 'training manager', 'sevener+', 'sevener'].include? user.access_level
  end
end
