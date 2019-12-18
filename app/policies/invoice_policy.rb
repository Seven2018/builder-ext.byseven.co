class InvoicePolicy < ApplicationPolicy
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

  def copy?
    check_access
  end

  def edit_client?
    check_access
  end

  def credit?
    check_access
  end

  def marked_as_send?
    check_access
  end

  def marked_as_paid?
    check_access
  end

  def marked_as_reminded?
    check_access
  end

  def upload_to_sheet?
    check_access
  end

  private

  def check_access
    ['super admin', 'admin', 'training manager'].include? user.access_level
  end
end
