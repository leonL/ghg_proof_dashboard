# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20151008154215) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "census_tracts", force: :cascade do |t|
    t.integer  "zone_id"
    t.decimal  "area"
    t.geometry "geom",       limit: {:srid=>4326, :type=>"multi_polygon"}
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "census_tracts", ["geom"], name: "index_census_tracts_on_geom", using: :gist

  create_table "ghg_emissions", force: :cascade do |t|
    t.integer  "zone_id"
    t.integer  "sector_id"
    t.integer  "fuel_type_id"
    t.integer  "scope"
    t.integer  "scenario_id"
    t.integer  "year"
    t.decimal  "total_emissions"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plotly_charts", force: :cascade do |t|
    t.string  "plotly_user"
    t.integer "plotly_id"
    t.string  "chart_type"
    t.string  "chart_name"
    t.integer "scenario_id"
  end

  create_table "scenarios", force: :cascade do |t|
    t.string "name"
    t.text   "description"
  end

  create_table "sectors", force: :cascade do |t|
    t.string "name"
  end

end
