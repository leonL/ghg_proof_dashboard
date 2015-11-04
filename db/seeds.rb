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

def seed_from_shapefile(shp_file_path, &block)
  puts "Seeding shapefile at #{shp_file_path}"
  RGeo::Shapefile::Reader.open(shp_file_path) do |file|
    puts "Shape file contains #{file.num_records} records."
    file.each do |record|
      block.call record
    end
  end
end

def plotly_chart_names
  {
    scenario_specific: ['emissions_by_sector', 'emissions_by_fuel_type'],
    scenario_independent: ['emissions_total']
  }
end

def colour_palettes
  {
    scenario: [
      '#1f77b4',
      '#aec7e8',
      '#ff7f0e',
      '#ffbb78',
      '#2ca02c',
      '#98df8a',
      '#d62728',
      '#ff9896',
      '#9467bd',
      '#c5b0d5',
      '#8c564b',
      '#c49c94',
      '#e377c2',
      '#f7b6d2',
      '#7f7f7f',
      '#c7c7c7',
      '#bcbd22',
      '#dbdb8d',
      '#17becf',
      '#9edae5'
    ],
    fuel_type: [
      '#1f77b4',
      '#ff7f0e',
      '#2ca02c',
      '#d62728',
      '#9467bd',
      '#8c564b',
      '#e377c2',
      '#7f7f7f',
      '#bcbd22',
      '#17becf'
    ],
    sector: [
      '#8c564b',
      '#e377c2',
      '#7f7f7f',
      '#bcbd22',
      '#17becf',
      '#1f77b4',
      '#ff7f0e',
      '#2ca02c',
      '#d62728',
      '#9467bd'
    ]
  }
end

# seed all colours
puts "Seeding colours"
colour_palettes.each do |palette, colours|
  colours.each do |colour_code|
    Colour.create(hex: colour_code, palette: palette)
  end
end

# seed all scenarios
scenario_colour_ids_cycle = Colour.for_palette('scenario').pluck(:id).cycle

puts "Seeding scenarios..."
CSV.foreach("#{Rails.root}/db/seed_csvs/scenarios.csv", headers:true) do |row|
  Scenario.create(
    id: row['id'],
    name: row['name'],
    description: row['description'],
    colour_id: scenario_colour_ids_cycle.next
  )
end

# seed all fuel types
fuel_type_colour_ids_cycle = Colour.for_palette('fuel_type').pluck(:id).cycle

puts "Seeding fuel types..."
CSV.foreach("#{Rails.root}/db/seed_csvs/fuel_types.csv", headers:true) do |row|
  FuelType.create(
    id: row['id'],
    name: row['name'],
    colour_id: fuel_type_colour_ids_cycle.next
  )
end

# seed all sectors
sector_colour_ids_cycle = Colour.for_palette('sector').pluck(:id).cycle

puts "Seeding sectors..."
CSV.foreach("#{Rails.root}/db/seed_csvs/sectors.csv", headers:true) do |row|
  Sector.create(
    id: row['id'],
    name: row['name'],
    colour_id: sector_colour_ids_cycle.next
  )
end

puts "Seeding reductions summaries..."
CSV.foreach("#{Rails.root}/db/seed_csvs/summaryData.csv", headers:true, skip_blanks:true, skip_lines:Regexp.new('!')) do |row|
  EmissionsReductionSummary.create(
    benchmark_year: row['timeFilt'],
    benchmark_type: row['ComparisonType'],
    scenario_id: row["scenarioID"],
    total_Mt: row["CO2eq_reduction_Mt"],
    percent: row["%_CO2eq_reduction"],
    per_capita_t: row["per_capita_reduction_tonnePerPerson"],
    percent_per_capita: row["%_per_capita_reduction"]
  )
end

# seed census tract geometries
seed_from_shapefile("#{Rails.root}/db/shpfiles/census_tracts/toronto_ct.shp") do |record|
  CensusTract.create(
    zone_id: record.attributes['ZONEID'],
    area: record.attributes['AREA'],
    geom: record.geometry.as_text
  )
end

# import ghg_emissions csvs
(1..3).each do |n|
  puts "Seeding ghg_emissions for scenario #{n}..."
  copy_emissions_csv(n)
end

# Create Plotly Charts
puts "Creating Plotly Charts..."
plotly_chart_names[:scenario_independent].each do |cn|
  pc = PlotlyChart.find_or_create_by(chart_name: cn)
  puts pc.chart_name
end

plotly_chart_names[:scenario_specific].each do |cn|
  Scenario.all.each do |scenario|
    pc = PlotlyChart.find_or_create_by(chart_name: cn, scenario_id: scenario.id)
    puts "#{pc.chart_name} for #{scenario.name}"
  end
end