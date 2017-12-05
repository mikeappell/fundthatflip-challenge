# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171205034727) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "data_points", force: :cascade do |t|
    t.integer "location_id"
    t.string "name"
    t.string "sys_country"
    t.integer "sys_sunrise"
    t.integer "sys_sunset"
    t.float "coord_lat"
    t.float "coord_lon"
    t.integer "weather_id"
    t.string "weather_main"
    t.string "weather_description"
    t.string "weather_icon"
    t.float "main_temp"
    t.integer "main_pressure"
    t.integer "main_humidity"
    t.float "main_temp_min"
    t.float "main_temp_max"
    t.integer "visibility"
    t.float "wind_speed"
    t.integer "wind_deg"
    t.float "wind_gust"
    t.integer "clouds_all"
    t.integer "dt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
