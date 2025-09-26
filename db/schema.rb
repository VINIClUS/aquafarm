# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_09_06_130000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "farms", force: :cascade do |t|
    t.string "name"
    t.string "subdomain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_farms_on_user_id"
  end

  create_table "ponds", force: :cascade do |t|
    t.string "name"
    t.integer "volume"
    t.bigint "farm_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["farm_id"], name: "index_ponds_on_farm_id"
  end

  create_table "sensor_readings", force: :cascade do |t|
    t.bigint "pond_id", null: false
    t.datetime "reading_time", null: false
    t.decimal "temp_c", precision: 5, scale: 2
    t.decimal "ph", precision: 4, scale: 2
    t.decimal "do_mg_l", precision: 5, scale: 2
    t.decimal "turbidity_ntu", precision: 7, scale: 2
    t.decimal "salinity_ppt", precision: 6, scale: 3
    t.boolean "flagged", default: false, null: false
    t.string "flag_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pond_id", "reading_time"], name: "index_sensor_readings_on_pond_id_and_reading_time", unique: true
    t.index ["pond_id"], name: "index_sensor_readings_on_pond_id"
    t.index ["reading_time"], name: "index_sensor_readings_on_reading_time"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "farms", "users"
  add_foreign_key "ponds", "farms"
  add_foreign_key "sensor_readings", "ponds"
end
