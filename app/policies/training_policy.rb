class TrainingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if ['super admin', 'user'].include? user.access_level
        scope.all
      else
        raise Pundit::NotAuthorizedError, 'not allowed to view this action'
      end
    end
  end

  def index_upcoming?
    check_access
  end

  def index_completed?
    check_access
  end

  def index_week?
    check_access
  end

  def index_month?
    check_access
  end

  def create?
    check_access
  end

  def show?
    check_access
  end

  def show_session_content?
    check_access
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
    check_access
  end

  def trainer_notification_email?
    check_access
  end

  private

  def check_access
    ['super admin', 'user'].include? user.access_level
  end
end
