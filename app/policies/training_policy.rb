class TrainingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if ['super admin', 'admin', 'training manager', 'sevener+', 'sevener'].include? user.access_level
        scope.all
      else
        raise Pundit::NotAuthorizedError, 'not allowed to view this action'
      end
    end
  end

  def index_upcoming?
    true
  end

  def index_completed?
    true
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

  def show_session_content?
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

  def copy?
    check_access
  end

  def invoice_form?
    true
  end

  def trainer_notification_email?
    check_access
  end

  private

  def check_access
    ['super admin', 'admin', 'training manager'].include? user.access_level
  end
end
