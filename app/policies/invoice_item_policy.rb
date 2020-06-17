class InvoiceItemPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if ['super admin', 'admin', 'training manager'].include? user.access_level
        scope.all
      else
        raise Pundit::NotAuthorizedError, 'not allowed to view this action'
      end
    end
  end

  def create?
    check_access
  end

  def show?
    true
  end

  def copy?
    check_access
  end

  def copy_here?
    check_access
  end

  def credit?
    ['super admin', 'admin'].include? user.access_level
  end

  def destroy?
    check_access
  end

  def new_invoice_item?
    true
  end

  def new_sevener_invoice?
    true
  end

  def new_estimate?
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

  def upload_to_drive?
    true
  end

  def report?
    ['super admin', 'admin'].include? user.access_level
  end

  def edit_client?
    ['super admin', 'admin'].include? user.access_level
  end

  private

  def check_access
    ['super admin', 'admin', 'training manager'].include? user.access_level
  end
end
