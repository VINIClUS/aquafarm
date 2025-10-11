# app/policies/farm_policy.rb
class FarmPolicy < ApplicationPolicy
  def index?   = true  # listado via policy_scope
  def create?  = owns_farm?
  def show?    = owns_farm?
  def update?  = owns_farm?
  def destroy? = owns_farm?

  class Scope < Scope
    def resolve
      scope.where(user_id: user.id)
    end
  end

  private

  def owns_farm?
    record.user_id == user.id
  end
end
