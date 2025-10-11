class PondPolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5
 # class Scope < Scope
  #  def resolve
      # retorna apenas os ponds do tenant corrente (o acts_as_tenant já faz o default_scope)
 #     scope.all
 #   end
  #end

  def index?   = true  # listado via policy_scope
  def show?    = owns_farm?
  def create?  = owns_farm_by_farm_id?
  def update?  = owns_farm?
  def destroy? = owns_farm?
  
  class Scope < Scope
    def resolve
      scope.joins(:farm).where(farms: { user_id: user.id })
    end
  end

  private

  def owns_farm?
    return false if record.farm_id.blank?
    # evita acessar record.farm quando ainda não carregou
    #Farm.exists?(id: record.farm_id, user_id: user.id)
    record.farm.user_id == user.id
  end

  def owns_farm_by_farm_id?
    Farm.exists?(id: record.farm_id, user_id: user.id)
  end
end
