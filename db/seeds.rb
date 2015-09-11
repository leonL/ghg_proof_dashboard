# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# def emissions_import_statement(scenario=0)
#   "COPY ghg_emissions(zone_id,sector_id,fuel_type_id,scope,scenario_id,year,total_emissions) " +
#   "FROM '#{Rails.root}/db/seed_csvs/mock_ghg_emissions_sc#{scenario}.csv' DELIMITER ',' CSV header;"
# end

# def emissions_sample_import_statement
#   "COPY ghg_emissions(zone_id,sector_id,fuel_type_id,scope,scenario_id,year,total_emissions) " +
#   "FROM '#{Rails.root}/db/seed_csvs/mock_ghg_emissions_sample.csv' DELIMITER ',' CSV header;"
# end

# (0..2).each do |n|
#   puts "Seeding GHG emisisons table for scenario #{n}"
#   ActiveRecord::Base.connection.execute emissions_import_statement(n)
# end

# Setup raw connection
conn = ActiveRecord::Base.connection
rc = conn.raw_connection
rc.exec("COPY ghg_emissions(zone_id,sector_id,fuel_type_id,scope,scenario_id,year,total_emissions) FROM STDIN WITH CSV header")

file = File.open("#{Rails.root}/db/seed_csvs/mock_ghg_emissions_sc0.csv", 'r')
while !file.eof?
  # Add row to copy data
  rc.put_copy_data(file.readline)
end

# We are done adding copy data
rc.put_copy_end

# Display any error messages
while res = rc.get_result
  if e_message = res.error_message
    p e_message
  end
end