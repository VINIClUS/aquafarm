class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  #allow_browser versions: :modern
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  
  set_current_tenant_through_filter
  before_action :set_tenant

  private

  def set_tenant
    puts ">>> Subdomínio recebido: #{request.subdomain.inspect}"
    # Use ::Farm para referir-se ao model global
    if Rails.env.development?
      farm = Farm.first  # ou algum ID específico
    else
    farm = ::Farm.find_by!(subdomain: request.subdomain)
    end
    
    ActsAsTenant.current_tenant = farm
  end

  def user_not_authorized
    flash[:alert] = 'Você não tem permissão para fazer isso.'
    redirect_to(request.referer || root_path)
  end
end
