class AttendeePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def form?
    true
  end

  def create?
    true
  end

  def show?
    check_access_seven
  end

  private

  def check_access_seven
    ['super admin', 'admin', 'training manager'].include? user.access_level
  end
end
