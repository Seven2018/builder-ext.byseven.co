class WorkshopModulePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    true
  end

  def show?
    true
  end

  def edit?
    true
  end

  def update?
    true
  end

  def destroy?
    true
  end

  def move_up?
    true
  end

  def move_down?
    true
  end

  def save?
    true
  end

  def viewer?
    true
  end
end
