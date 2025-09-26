# db/migrate/20250727145352_create_sensor_readings.rb
class CreateSensorReadings < ActiveRecord::Migration[8.0]
  def change
    create_table :sensor_readings do |t|
      t.references :pond, null: false, foreign_key: true, index: true

      t.datetime :reading_time, null: false, index: true

      # Métricas comuns na piscicultura (ajuste conforme seus sensores)
      t.decimal :temp_c,          precision: 5, scale: 2
      t.decimal :ph,              precision: 4, scale: 2
      t.decimal :do_mg_l,         precision: 5, scale: 2   # dissolved oxygen
      t.decimal :turbidity_ntu,   precision: 7, scale: 2
      t.decimal :salinity_ppt,    precision: 6, scale: 3

      # opcional: marca leituras com problema
      t.boolean :flagged, default: false, null: false
      t.string  :flag_reason

      t.timestamps
    end

    # Exemplo de unicidade por (pond, reading_time) se cada timestamp deve ser único
    add_index :sensor_readings, [:pond_id, :reading_time], unique: true
  end
end
