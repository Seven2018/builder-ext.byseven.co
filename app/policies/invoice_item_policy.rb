class InvoiceItemPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    check_access
  end

  def show?
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

  def new_invoice?
    check_access
  end

  private

  def check_access
    ['super admin', 'admin', 'training manager'].include? user.access_level
  end
end
