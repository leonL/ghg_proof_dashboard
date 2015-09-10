# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def emissions_import_statement(scenario=0)
  "COPY ghg_emissions(zone_id,sector_id,fuel_type_id,scope,scenario_id,year,total_emissions) " +
  "FROM '#{Rails.root}/db/seed_csvs/mock_ghg_emissions_sc#{scenario}.csv' DELIMITER ',' CSV header;"
end

(0..2).each do |n|
  puts "Seeding GHG emisisons table for scenario #{n}"
  ActiveRecord::Base.connection.execute emissions_import_statement(n)
end