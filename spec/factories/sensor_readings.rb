# spec/factories/sensor_readings.rb
FactoryBot.define do
  factory :sensor_reading do
    association :pond
    reading_time { Time.zone.now.change(sec: 0) }
    temp_c { 28.5 }
    ph { 7.1 }
    do_mg_l { 6.0 }
    turbidity_ntu { 0.3 }
    salinity_ppt { 0.25 }
  end
end
