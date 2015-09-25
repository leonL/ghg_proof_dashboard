# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def copy_emissions_csv(scenario_id)
  # Setup raw connection
  conn = ActiveRecord::Base.connection
  rc = conn.raw_connection
  rc.exec("COPY ghg_emissions(zone_id,sector_id,fuel_type_id,scope,scenario_id,year,total_emissions) FROM STDIN WITH CSV header")

  file = File.open("#{Rails.root}/db/seed_csvs/mock_ghg_emissions_sc#{scenario_id}.csv", 'r')
  while !file.eof?
    # Add row to copy data
    rc.put_copy_data(file.readline)
  end
  # We are done adding copy data
  rc.put_copy_end

  # Display any error messages
  errors = rc.get_result.error_message
  puts "Errors: #{errors}" unless errors.blank?
end

def seed_from_shapefile(shp_file_path, factory, &block)
  puts "Seeding shapefile at #{shp_file_path}"
  RGeo::Shapefile::Reader.open(shp_file_path, factory: factory) do |file|
    puts "Shape file contains #{file.num_records} records."
    file.each do |record|
      block.call record
    end
  end
end

# seed census tract geometries
srs_database = RGeo::CoordSys::SRSDatabase::ActiveRecordTable.new
factory_92958 = RGeo::Geos.factory(srs_database: srs_database, srid: 92958)
factory_4326 = RGeo::Geos.factory(srs_database: srs_database, srid: 4326)
seed_from_shapefile("#{Rails.root}/db/shpfiles/census_tracts/toronto_ct1.shp", factory_92958) do |record|
  recast_geometry = RGeo::Feature.cast(record.geometry, factory: factory_4326, project: true)
  CensusTract.create(
    zone_id: record.attributes['ZONEID'],
    area: record.attributes['AREA'],
    geom: recast_geometry.to_s
  )
end

# import ghg_emissions csvs
(0..2).each do |n|
  puts "Seeding ghg_emissions for scenario #{n}..."
  copy_emissions_csv(n)
end