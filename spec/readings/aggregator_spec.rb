# spec/services/readings/aggregator_spec.rb
require "rails_helper"

RSpec.describe Readings::Aggregator do
  let!(:pond) { create(:pond) }

  it "calcula médias diárias" do
    create(:sensor_reading, pond:, reading_time: Time.zone.parse("2025-09-05 08:00"), temp_c: 28, ph: 7.1)
    create(:sensor_reading, pond:, reading_time: Time.zone.parse("2025-09-05 16:00"), temp_c: 30, ph: 7.3)

    out = described_class.daily_averages(
      relation: pond.sensor_readings,
      start_at: Time.zone.parse("2025-09-05"),
      end_at:   Time.zone.parse("2025-09-06")
    )

    expect(out.size).to eq(1)
    expect(out.first["day"]).to eq("2025-09-05")
    expect(out.first["avg_temp_c"]).to be_within(0.001).of(29.0)
    expect(out.first["avg_ph"]).to be_within(0.001).of(7.2)
    expect(out.first["samples_count"]).to eq(2)
  end
end
