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
    check_access
  end

  def update?
    check_access
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
    check_access
  end

  def copy_form?
    check_access
  end

  def copy?
    check_access
  end

  private

  def check_access
    ['super admin', 'user'].include? user.access_level
  end
end
