class EstimatePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    check_access
  end

  def destroy?
    check_access
  end

  def new_invoice_item?
    check_access
  end

  def marked_as_paid?
    check_access
  end

  private

  def check_access
    ['super admin', 'admin', 'training manager'].include? user.access_level
  end
end
