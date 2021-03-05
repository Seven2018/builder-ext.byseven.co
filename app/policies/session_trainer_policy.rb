class SessionTrainerPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    check_access_seven
  end

  def create_all?
    check_access_seven
  end

  def update_calendar?
    check_access_seven
  end

  def destroy?
    check_access_seven
  end

  private

  def check_access_seven
    ['super admin', 'admin', 'training manager'].include? user.access_level
  end
end
