# spec/requests/timeseries_request_spec.rb
require "rails_helper"

RSpec.describe "Timeseries endpoint", type: :request do
  let(:user)  { create(:user) }
  let(:farm)  { create(:farm, user:) }
  let(:pond)  { create(:pond, farm:) }

  before do
    sign_in user
    10.times do |i|
      create(:sensor_reading, pond:, reading_time: Time.zone.now - i.hours, temp_c: 25 + i*0.1, ph: 7.0 + i*0.01)
    end
  end

  it "retorna série temporal com as métricas pedidas" do
    get timeseries_pond_sensor_readings_path(pond, format: :json), params: { n: 5, metrics: "temp_c,ph", stride: 2 }
    expect(response).to have_http_status(:accepted)
    json = JSON.parse(response.body)
    expect(json["pond_id"]).to eq(pond.id)
    expect(json["metrics"]).to eq(%w[temp_c ph])
    expect(json["count"]).to eq(5)
    expect(json["series"]).to be_an(Array)
    expect(json["series"].first).to have_key("t")
    expect(json["series"].first).to have_key("temp_c")
  end
end
