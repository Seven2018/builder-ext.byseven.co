class InvoicePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
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

  def copy?
    check_access_seven
  end

  def edit_client?
    check_access_seven
  end

  def credit?
    check_access_seven
  end

  def marked_as_send?
    check_access_seven
  end

  def marked_as_paid?
    check_access_seven
  end

  def marked_as_reminded?
    check_access_seven
  end

  def upload_to_sheet?
    check_access_seven
  end

  private

  def check_access_seven
    ['super admin', 'admin', 'training manager'].include? user.access_level
  end
end
