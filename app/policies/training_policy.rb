class TrainingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if ['super admin', 'admin', 'training manager', 'sevener'].include? user.access_level
        scope.all
      else
        raise Pundit::NotAuthorizedError, 'not allowed to view this action'
      end
    end
  end

  def index_week?
    true
  end

  def index_month?
    true
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

  def update_survey?
    check_access
  end

  def destroy?
    check_access
  end

  def copy?
    check_access
  end

  private

  def check_access
    ['super admin', 'admin', 'training manager'].include? user.access_level
  end
end
