# spec/requests/sensor_readings_request_spec.rb
require "rails_helper"

RSpec.describe "SensorReadings", type: :request do
  let!(:pond) { create(:pond) }

  describe "GET /ponds/:pond_id/sensor_readings" do
    it "lista leituras" do
      create_list(:sensor_reading, 3, pond:)
      get pond_sensor_readings_path(pond)
      expect(response).to have_http_status(:accepted)
    end
  end

  describe "POST /ponds/:pond_id/sensor_readings" do
    it "cria leitura válida" do
      params = { sensor_reading: { reading_time: Time.zone.now, temp_c: 27.5, ph: 7.1 } }
      post pond_sensor_readings_path(pond), params:
      params
      expect(response).to redirect_to(/sensor_readings/)
      expect(SensorReading.count).to eq(1)
    end
  end
end
