class ActionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if ['super admin', 'admin', 'training manager'].include? user.access_level
        scope.all
      else
        raise Pundit::NotAuthorizedError, 'not allowed to view this action'
      end
    end
  end

  def create?
    check_access_seven
  end

  def show?
    true
  end

  def edit?
    check_access_seven
  end

  def update?
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
