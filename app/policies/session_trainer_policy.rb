class SessionTrainerPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    check_access
  end

  def create_all?
    check_access
  end

  def update_calendar?
    check_access
  end

  def destroy?
    check_access
  end

  private

  def check_access
    ['super admin', 'user'].include? user.access_level
  end
end
