require "rails_helper"

RSpec.describe "Ingest API", type: :request do
  describe "POST /ingest/sensor_readings" do
    let!(:user) { create(:user) }
    let!(:farm) { create(:farm, user: user) }
    let!(:pond) { create(:pond, farm: farm) }

    let(:metrics) { { temp_c: 29.1, ph: 7.0, do_mg_l: 6.3 } }
    let(:payload) do
      {
        pond_id: pond.id,
        reading_time: "2025-09-06T10:00:00-03:00",
        metrics: metrics
      }
    end
    
    it "cria uma leitura e retorna 201/accepted" do
      expect {
        perform_enqueued_jobs do
          post "/ingest/sensor_readings",
               params: payload.to_json,
               headers: { "Content-Type" => "application/json" }
          expect(response).to have_http_status(:accepted)
          body = JSON.parse(response.body)
          expect(body["status"]).to eq("queued")
        end
      }.to change(SensorReading, :count).by(1)

      sr = SensorReading.last
      expect(sr.pond_id).to eq(pond.id)
      expect(sr.temp_c.to_f).to eq(29.1)
      expect(sr.ph.to_f).to eq(7.0)
      expect(sr.do_mg_l.to_f).to eq(6.3)
    end

    it "retorna 404 quando pond_id não existe" do
      bad = payload.merge(pond_id: 999_999)
      expect {
        post "/ingest/sensor_readings",
             params: bad.to_json,
             headers: { "Content-Type" => "application/json" }
      }.not_to change(SensorReading, :count)

      expect(response).to have_http_status(:not_found)
      body = JSON.parse(response.body)
      expect(body["error"]).to match(/Pond inexistente/i)
    end

    it "aceita métricas parciais" do
      partial = payload.merge(metrics: { temp_c: 30.2 })

      perform_enqueued_jobs do
        post "/ingest/sensor_readings",
            params: partial.to_json,
            headers: { "Content-Type" => "application/json" }
      expect(response).to have_http_status(:accepted)
      end
      
      sr = SensorReading.last
      expect(sr.temp_c.to_f).to eq(30.2)
      expect(sr.ph).to be_nil.or eq(0) # conforme default/NULL no seu schema
    end

    it "é compatível com perform_later (se controller mudar no futuro)" do
      # Se o controller passar a usar perform_later, esse teste seguirá válido
      ActiveJob::Base.queue_adapter = :test
      expect {
        post "/ingest/sensor_readings",
             params: payload.to_json,
             headers: { "Content-Type" => "application/json" }
      }.to change { SensorReading.count }.by(1).or change { enqueued_jobs.size }.by(1)
    ensure
      ActiveJob::Base.queue_adapter = :async
    end
  end
end
