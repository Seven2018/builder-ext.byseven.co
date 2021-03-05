class EstimatePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if ['super admin', 'admin', 'training manager'].include? user.access_level
        scope.all
      else
        raise Pundit::NotAuthorizedError, 'not allowed to view this action'
      end
    end
  end

  def show?
    check_access_seven
  end

  def destroy?
    check_access_seven
  end

  def new_invoice_item?
    check_access_seven
  end

  def marked_as_paid?
    check_access_seven
  end

  private

  def check_access_seven
    ['super admin', 'admin', 'training manager'].include? user.access_level
  end
end
