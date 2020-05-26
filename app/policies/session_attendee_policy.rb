class SessionAttendeePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    true
  end

  def destroy?
    true
  end

  def create_kea_partners?
    true
  end

  def destroy_kea_partners?
    true
  end
end
