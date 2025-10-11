class SensorReadingPolicy < ApplicationPolicy
  #class Scope < Scope
  def index?   = true  # listado via policy_scope
  def show?    = owns_farm?
  def create?  = owns_farm_by_pond_id?
  def update?  = owns_farm?
  def destroy? = owns_farm?

  class Scope < Scope
    def resolve
      scope.joins(pond: :farm).where(farms: { user_id: user.id }) # filtra leituras de tanques pertencentes a fazendas do usuário
      #scope.where(pond_id: user.ponds.select(:id)) # alternativa: filtra leituras de tanques pertencentes ao usuário
      #scope.all #--- IGNORE ---
    end
  end

  private

    def owns_farm?
      record.pond&.farm&.user_id == user.id
    end

    def owns_farm_by_pond_id?
    return false if record.pond_id.blank?
    Farm.joins(:ponds).where(user_id: user.id, ponds: { id: record.pond_id }).exists?
    end
  end
