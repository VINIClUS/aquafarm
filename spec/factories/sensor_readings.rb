# spec/factories/sensor_readings.rb
FactoryBot.define do
  factory :sensor_reading do
    association :pond
    reading_time { Time.zone.now }
    temp_c { 28.5 }
    ph { 7.4 }
    do_mg_l { 6.2 }
    turbidity_ntu { 12.3 }
    salinity_ppt { 0.5 }
  end
end
