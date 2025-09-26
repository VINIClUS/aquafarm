# spec/jobs/ingest_sensor_reading_job_spec.rb
require "rails_helper"

RSpec.describe IngestSensorReadingJob, type: :job do
  let!(:pond) { create(:pond) }

  it "cria uma leitura a partir do payload" do
    payload = {
      "pond_id" => pond.id,
      "reading_time" => "2025-09-06T10:00:00-03:00",
      "metrics" => { "temp_c" => 28.7, "ph" => 7.3 }
    }
    expect {
      described_class.perform_now(payload)
    }.to change { SensorReading.count }.by(1)
  end
end
