class CategoryPolicy < ApplicationPolicy
  def update?
    user.admin?
  end
end
