# app/jobs/ingest_sensor_reading_job.rb
class IngestSensorReadingJob < ApplicationJob
  #qqueue_as :default
  include JobLogging

  def perform(payload)
    #user = User.find(payload["user_id"]) if payload["user_id"]
    #pond = resolve_pond(payload, user)

    pond = resolve_only_pond(payload)
    raise ActiveRecord::RecordNotFound, "Pond not found / not owned" unless pond

    reading_time = parse_time(payload["reading_time"]) || Time.zone.now
    metrics = payload["metrics"] || {}

    SensorReading.create!(
      pond: pond,
      reading_time: reading_time,
      temp_c: metrics["temp_c"],
      ph: metrics["ph"],
      do_mg_l: metrics["do_mg_l"],
      turbidity_ntu: metrics["turbidity_ntu"],
      salinity_ppt: metrics["salinity_ppt"]
    )
  rescue => e
    Rails.logger.error j("[IngestSensorReadingJob] Failed: #{e.class} - #{e.message}")
  end

  private

  def resolve_only_pond(payload)
    if payload["pond_id"].present?
      Pond.find_by(id: payload["pond_id"])
    elsif payload["pond_external_id"].present?
      Pond.find_by(external_id: payload["pond_external_id"])
    end
  end

  def resolve_pond(payload, user)
    scope = Pond.joins(:farm).where(farms: { user_id: user.id }) if user
    if payload["pond_id"].present?
      (scope || Pond).find_by(id: payload["pond_id"])
    elsif payload["pond_external_id"].present?
      (scope || Pond).find_by(external_id: payload["pond_external_id"])
    end
  end

  def parse_time(value)
    return value if value.is_a?(Time) || value.is_a?(ActiveSupport::TimeWithZone)
    Time.zone.parse(value.to_s)
  rescue
    nil
  end
end
