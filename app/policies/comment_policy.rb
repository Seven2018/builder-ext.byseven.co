class CommentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    check_access
  end

  def destroy?
    check_access
  end

  private

  def check_access
    ['super admin', 'admin', 'training manager', 'sevener+', 'sevener'].include? user.access_level
  end
end
