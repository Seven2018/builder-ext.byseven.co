class IntelligencePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if ['super admin', 'user'].include? user.access_level
        scope.all
      else
        raise Pundit::NotAuthorizedError, 'not allowed to view this action'
      end
    end
  end

  def create?
    check_access
  end

  def show?
    true
  end

  def edit?
    check_access
  end

  def update?
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
