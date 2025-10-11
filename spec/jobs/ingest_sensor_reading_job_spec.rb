require "rails_helper"

RSpec.describe IngestSensorReadingJob, type: :job do
  let!(:owner)    { create(:user) }
  let!(:farm)     { create(:farm, user: owner) }
  let!(:pond)     { create(:pond, farm: farm) }
  let(:metrics)   { { "temp_c" => 27.4, "ph" => 7.2, "do_mg_l" => 6.1 } }

  it "cria leitura resolvendo por pond_id" do
    payload = {
      "pond_id" => pond.id,
      "reading_time" => "2025-09-01T12:00:00-03:00",
      "metrics" => metrics
    }

    expect {
      described_class.perform_now(payload)
    }.to change(SensorReading, :count).by(1)

    sr = SensorReading.last
    expect(sr.pond_id).to eq(pond.id)
    expect(sr.temp_c.to_f).to eq(27.4)
    expect(sr.ph.to_f).to eq(7.2)
    expect(sr.do_mg_l.to_f).to eq(6.1)
  end

  it "cria leitura resolvendo por pond_external_id (se existir a coluna)" do
    if pond.respond_to?(:external_id)
      pond.update!(external_id: "ext-123")
      payload = { "pond_external_id" => "ext-123", "metrics" => metrics }

      expect {
        described_class.perform_now(payload)
      }.to change(SensorReading, :count).by(1)

      expect(SensorReading.last.pond_id).to eq(pond.id)
    else
      skip "Ponds não possui external_id — teste ignorado"
    end
  end

  it "usa Time.zone.now quando reading_time é inválido" do
    now = Time.zone.now.change(usec: 0)

    travel_to now do
      payload = { "pond_id" => pond.id, "reading_time" => "xxx", "metrics" => metrics }
      described_class.perform_now(payload)
      expect(SensorReading.last.reading_time.change(usec: 0)).to eq(now)
    end
  end

  it "lida com metrics ausente (usa {})" do
    payload = { "pond_id" => pond.id }
    expect {
      described_class.perform_now(payload)
    }.to change(SensorReading, :count).by(1)
    expect(SensorReading.last.pond_id).to eq(pond.id)
  end
  

  #context "com token" do
  #before { stub_const("ENV", ENV.to_h.merge("INGEST_TOKEN" => "abc123")) }

  #it "rejeita sem header X-INGEST-TOKEN" do
  #  post "/ingest/sensor_readings",
  #       params: payload.to_json,
  #       headers: { "Content-Type" => "application/json" }
  #  expect(response).to have_http_status(:unauthorized)
  #end

  #it "aceita com header X-INGEST-TOKEN válido" do
  #  post "/ingest/sensor_readings",
  #       params: payload.to_json,
  #       headers: { "Content-Type" => "application/json", "X-INGEST-TOKEN" => "abc123" }
  #  expect(response).to have_http_status(:created)
  #end
end
