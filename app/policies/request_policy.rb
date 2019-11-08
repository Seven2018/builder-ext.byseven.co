class RequestPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    check_access
  end

  def destroy?
    check_access
  end

  private

  def check_access
    ['HR', 'employee'].include? (user.access_level)
  end
end
