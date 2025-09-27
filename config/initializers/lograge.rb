Rails.application.configure do
  # Ativar em prod:
  config.lograge.enabled = !Rails.env.test?

  # Saída em JSON, 1 linha por request
  config.lograge.formatter = Lograge::Formatters::Json.new

  # Reduzir o ruído dos params (Rails já filtra os sensíveis)
  config.filter_parameters += %i[password token api_key]

  # Campos extras úteis para debugar
  config.lograge.custom_options = lambda do |event|
    payload = event.payload

    {
      request_id: payload[:request_id],
      user_id:    payload[:current_user]&.id,            
      remote_ip:  payload[:ip],
      params:     payload[:params].except(*Rails.configuration.filter_parameters),
      duration_ms: (event.duration || 0.0).round(1),
    }.compact
  end

  # Payload com ip, user, params
  config.lograge.custom_payload do |controller|
    {
      request_id: controller.request.request_id,
      ip:         controller.request.headers["X-Forwarded-For"] || controller.request.remote_ip,
      current_user: (controller.try(:current_user) if controller.respond_to?(:current_user)),
      params:     controller.request.filtered_parameters.slice("controller","action","pond_id","start_at","end_at")
    }
  end
end
