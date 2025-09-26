class SensorReadingPolicy < ApplicationPolicy
  class Scope < Scope
  def index?   = true  # listado via policy_scope
  def show?    = owns_farm?
  def create?  = owns_farm?
  def update?  = owns_farm?
  def destroy? = owns_farm?

  class Scope < Scope
    def resolve
      scope.joins(pond: :farm).where(farms: { user_id: user.id })
    end
  end

  private

    def owns_farm?
      record.pond&.farm&.user_id == user.id
    end
  end
end
