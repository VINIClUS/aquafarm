# spec/requests/sensor_readings_csv_spec.rb
require "rails_helper"

RSpec.describe "SensorReadings CSV", type: :request do
  let!(:pond) { create(:pond) }
  let!(:r1)   { create(:sensor_reading, pond:, reading_time: Time.zone.parse("2025-09-05 10:00")) }
  let!(:r2)   { create(:sensor_reading, pond:, reading_time: Time.zone.parse("2025-09-05 12:00")) }

  it "exporta CSV" do
    get pond_sensor_readings_path(pond, format: :csv), params: { start_at: "2025-09-05", end_at: "2025-09-06" }
    expect(response).to have_http_status(:ok)
    expect(response.headers["Content-Type"]).to include("text/csv")
    expect(response.body).to include("id,pond_id,pond_name,reading_time")
    expect(response.body).to include(r1.id.to_s, r2.id.to_s)
  end
end
