# app/controllers/ingest/ingest_controller.rb
class Ingest::IngestController < ActionController::API
  include JsonLog
  #before_action :check_token
  
  def sensor_readings
    payload = params.to_unsafe_h  # aceita hash aninhado "metrics"
    started = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    # valida existência do pond quando informado
    if payload["pond_id"].present? && !Pond.exists?(id: payload["pond_id"])
      INGEST_LOGGER.warn j(event: "ingest.reject", reason: "pond_not_found", pond_id: payload["pond_id"])
      return render json: { error: "Pond inexistente" }, status: :not_found
    end

    job = IngestSensorReadingJob.perform_later(payload)
    elapsed = ((Process.clock_gettime(Process::CLOCK_MONOTONIC) - started) * 1000).round(1)
    # provider_job_id pode ser nil dependendo do adapter; job_id sempre existe
    # Log bem compacto: ID do pond, job e ISO8601
    INGEST_LOGGER.info j(
      event: "ingest.queued",
      job_id: job.job_id,
      provider_job_id: (job.try(:provider_job_id) rescue nil),
      worker: job.queue_name,
      pond_id: payload["pond_id"],
      has_external: payload.key?("pond_external_id"),
      reading_time: payload["reading_time"],
      metrics: payload["metrics"] ? payload["metrics"].keys : [],
      duration_ms: elapsed
    )

    render json: {
      status: "queued",
      job_id: job.job_id,
      provider_job_id: (job.try(:provider_job_id) rescue nil)
    }, status: :accepted
  rescue => e
    INGEST_LOGGER.error j(event: "ingest.error", error: e.class.to_s, message: e.message, backtrace: e.backtrace&.first(3))
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