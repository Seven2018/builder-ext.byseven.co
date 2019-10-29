class TrainingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index_booklet?
    check_access_hr
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

  def destroy?
    check_access
  end

  private

  def check_access_hr
    ['super admin', 'admin', 'training manager', 'HR'].include? user.access_level
  end

  def check_access
    ['super admin', 'admin', 'training manager'].include? user.access_level
  end
end
