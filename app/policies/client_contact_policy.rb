class ClientContactPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    user.access_level == "admin"
  end

  def show?
    true
  end

  def edit?
    user.access_level == "admin"
  end

  def update?
    user.access_level == "admin"
  end

  def destroy?
    user.access_level == "admin"
  end
end
