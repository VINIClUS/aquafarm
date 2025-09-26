# app/controllers/ingest/sensor_readings_controller.rb
class Ingest::SensorReadingsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  def create
    payload = params.to_unsafe_h
    # valida ownership do pond antes de enfileirar
    if payload["pond_id"].present?
      pond = policy_scope(Pond).find_by(id: payload["pond_id"])
      return render json: { error: "Pond não encontrado" }, status: :not_found unless pond
    end

    IngestSensorReadingJob.perform_later(payload.merge("user_id" => current_user.id))
    render json: { status: "queued" }, status: :accepted
  end
end
