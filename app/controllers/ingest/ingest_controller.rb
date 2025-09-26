# app/controllers/ingest/ingest_controller.rb
class Ingest::IngestController < ActionController::API
  # POST /ingest/sensor_readings
  #before_action :check_token
  def sensor_readings
    payload = params.to_unsafe_h  # aceita hash aninhado "metrics"

    # valida existência do pond quando informado
    if payload["pond_id"].present? && !Pond.exists?(id: payload["pond_id"])
      return render json: { error: "Pond inexistente" }, status: :not_found
    end

    # Enquanto estiver testando/dev: execute síncrono p/ ver erros na hora
    reading = IngestSensorReadingJob.perform_now(payload)

    render json: {
      status: "ok",
      id: reading.id,
      pond_id: reading.pond_id,
      reading_time: reading.reading_time
    }, status: :created
  rescue => e
    render json: { status: "error", error: e.class.to_s, message: e.message }, status: :unprocessable_entity
  end

  private

  def check_token
    expected = ENV.fetch("INGEST_TOKEN", nil)
    return if expected.blank? # sem token em dev
    provided = request.headers["X-INGEST-TOKEN"]
    head :unauthorized unless ActiveSupport::SecurityUtils.secure_compare(provided.to_s, expected.to_s)
  end
end