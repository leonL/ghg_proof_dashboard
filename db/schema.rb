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

ActiveRecord::Schema.define(version: 20151129022741) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "age_groups", force: :cascade do |t|
    t.string  "name"
    t.integer "colour_id"
  end

  create_table "census_tracts", force: :cascade do |t|
    t.integer  "zone_id"
    t.decimal  "area"
    t.geometry "geom",       limit: {:srid=>4326, :type=>"multi_polygon"}
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "census_tracts", ["geom"], name: "index_census_tracts_on_geom", using: :gist

  create_table "colours", force: :cascade do |t|
    t.string "hex"
    t.string "palette"
  end

  create_table "emissions_summaries", force: :cascade do |t|
    t.string  "benchmark_type"
    t.integer "scenario_id"
    t.integer "benchmark_year"
    t.decimal "total_change_Mt"
    t.decimal "per_capita_change_t"
    t.decimal "percent_change"
    t.decimal "percent_per_capita_change"
  end

  create_table "end_uses", force: :cascade do |t|
    t.string  "name"
    t.integer "colour_id"
  end

  create_table "energy_by_end_use_totals", force: :cascade do |t|
    t.integer "scenario_id"
    t.integer "year"
    t.decimal "total"
    t.integer "end_use_id"
    t.integer "fuel_type_id"
  end

  create_table "energy_flow_totals", force: :cascade do |t|
    t.integer "scenario_id"
    t.integer "source_id"
    t.string  "source_type"
    t.integer "target_id"
    t.string  "target_type"
    t.integer "year"
    t.decimal "total"
  end

  create_table "energy_summaries", force: :cascade do |t|
    t.string  "benchmark_type"
    t.integer "scenario_id"
    t.integer "benchmark_year"
    t.decimal "total_use_change_PJ"
    t.decimal "per_capita_use_change_GJ"
    t.decimal "percent_use_change"
    t.decimal "percent_use_per_capita_change"
  end

  create_table "energy_totals", force: :cascade do |t|
    t.integer "scenario_id"
    t.integer "year"
    t.decimal "total"
    t.integer "sector_id"
    t.integer "fuel_type_id"
  end

  create_table "energy_use_totals_by_zone_sector_fuel", force: :cascade do |t|
    t.integer "scenario_id"
    t.integer "zone_id"
    t.integer "year"
    t.decimal "total"
    t.integer "sector_id"
    t.integer "fuel_type_id"
  end

  create_table "energy_utilizations", force: :cascade do |t|
    t.string  "name"
    t.integer "colour_id"
  end

  create_table "fuel_types", force: :cascade do |t|
    t.string  "name"
    t.integer "colour_id"
  end

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

  create_table "household_totals", force: :cascade do |t|
    t.integer "population_context_id"
    t.integer "year"
    t.decimal "total"
  end

  create_table "plotly_charts", force: :cascade do |t|
    t.string  "plotly_user"
    t.integer "plotly_id"
    t.string  "chart_type"
    t.string  "chart_name"
    t.integer "scenario_id"
  end

  create_table "population_totals_by_age_group", force: :cascade do |t|
    t.integer "population_context_id"
    t.integer "year"
    t.decimal "total"
    t.integer "age_group_id"
  end

  create_table "scenarios", force: :cascade do |t|
    t.string  "name"
    t.text    "description"
    t.integer "colour_id"
    t.boolean "bau"
  end

  create_table "sectors", force: :cascade do |t|
    t.string  "name"
    t.integer "colour_id"
  end

end
