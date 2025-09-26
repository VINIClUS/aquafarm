# spec/models/sensor_reading_spec.rb
require "rails_helper"

RSpec.describe SensorReading, type: :model do
  it "é válido com valores dentro dos limites" do
    expect(build(:sensor_reading)).to be_valid
  end

  it "falha com pH inválido" do
    expect(build(:sensor_reading, ph: 15)).not_to be_valid
  end

  it "auto-flag quando fora dos limites" do
    r = build(:sensor_reading, ph: 5.9)
    r.save!
    expect(r.flagged).to be true
    expect(r.flag_reason).to include("pH")
  end

  it "escopo between filtra por intervalo" do
    pond = create(:pond)
    a = create(:sensor_reading, pond:, reading_time: 2.days.ago)
    b = create(:sensor_reading, pond:, reading_time: 1.day.ago)
    range = 36.hours.ago..12.hours.ago
    expect(SensorReading.between(range.begin, range.end)).to include(b)
    expect(SensorReading.between(range.begin, range.end)).not_to include(a)
  end
end
