# app/services/readings/aggregator.rb
module Readings
  class Aggregator
    # Uso:
    # Readings::Aggregator.daily_averages(relation: SensorReading.where(pond_id: 1), start_at: 7.days.ago, end_at: Time.zone.now)
    #
    # Retorna um array de hashes [{ "day" => "2025-09-01", "avg_temp_c" => 28.3, ... }, ...]
    def self.daily_averages(relation:, start_at: nil, end_at: nil)
      rel = relation
      if start_at && end_at
        rel = rel.where(reading_time: start_at..end_at)
      end

      rel = rel.reorder(nil)
      # Postgres: DATE(reading_time)
      rel
        .select(
          "DATE(reading_time) AS day",
          "AVG(temp_c) AS avg_temp_c",
          "AVG(ph) AS avg_ph",
          "AVG(do_mg_l) AS avg_do_mg_l",
          "AVG(turbidity_ntu) AS avg_turbidity_ntu",
          "AVG(salinity_ppt) AS avg_salinity_ppt",
          "COUNT(*) AS samples_count"
        )
        .group("DATE(reading_time)")
        .order(Arel.sql("day ASC"))
        .map { |r|
          {
            "day" => r.day.to_s,
            "avg_temp_c" => r.avg_temp_c&.to_f,
            "avg_ph" => r.avg_ph&.to_f,
            "avg_do_mg_l" => r.avg_do_mg_l&.to_f,
            "avg_turbidity_ntu" => r.avg_turbidity_ntu&.to_f,
            "avg_salinity_ppt" => r.avg_salinity_ppt&.to_f,
            "samples_count" => r.samples_count.to_i
          }
        }
    end
  end
end
