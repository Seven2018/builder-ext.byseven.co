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
    true
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

  def new_sevener_invoice?
    true
  end

  def upload_to_sheet?
    check_access
  end

  def report?
    true
  end

  private

  def check_access
    ['super admin', 'admin', 'training manager'].include? user.access_level
  end
end
