require "#{Rails.root}/db/seed_lib.rb"

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
CSV.foreach("#{Rails.root}/db/data/scenario.csv", headers:true) do |row|
  Scenario.create(
    id: row['scenarioID'],
    name: row['scenarioNames'],
    bau: row['isBAU'],
    colour_id: scenario_colour_ids_cycle.next
  )
end

# seed all fuel types
fuel_type_colour_ids_cycle = Colour.for_palette('fuel_type').pluck(:id).cycle

puts "Seeding fuel types..."
CSV.foreach("#{Rails.root}/db/data/fuel_type.csv", headers:true) do |row|
  FuelType.create(
    id: row['id'],
    name: row['name'],
    colour_id: fuel_type_colour_ids_cycle.next
  )
end

# seed all sectors
sector_colour_ids_cycle = Colour.for_palette('sector').pluck(:id).cycle

puts "Seeding sectors..."
CSV.foreach("#{Rails.root}/db/data/sector.csv", headers:true) do |row|
  Sector.create(
    id: row['id'],
    name: row['name'],
    colour_id: sector_colour_ids_cycle.next
  )
end

# seed all end uses
end_use_colour_ids_cycle = Colour.for_palette('end_use').pluck(:id).cycle

puts "Seeding end uses..."
CSV.foreach("#{Rails.root}/db/data/end_use.csv", headers:true) do |row|
  EndUse.create(
    id: row['id'],
    name: row['name'],
    colour_id: end_use_colour_ids_cycle.next
  )
end

# seed all age groups
age_group_colour_ids_cycle = Colour.for_palette('age_group').pluck(:id).cycle

puts "Seeding end uses..."
CSV.foreach("#{Rails.root}/db/data/age_group.csv", headers:true) do |row|
  AgeGroup.create(
    id: row['id'],
    name: row['name'],
    colour_id: age_group_colour_ids_cycle.next
  )
end

# import population by age
puts "Seeding population_totals_by_age_group..."
import_large_csv(
  "#{Rails.root}/db/data/Demographics/populationByAge.csv",
  'population_totals_by_age_group(population_context_id, year, total, age_group_id)'
)

scenario_ids = Scenario.pluck :id

scenario_ids.each do |scenario_id|

  # import ghg_emissions csvs
  puts "Seeding ghg_emissions for scenario #{scenario_id}..."
  import_large_csv(
    "#{Rails.root}/db/data/Emissions/emissionsDetailed_#{scenario_id}.csv",
    'ghg_emissions(scenario_id, zone_id, scope, year, total_emissions, sector_id, fuel_type_id)'
  )

  # import ghg_emissions csvs
  puts "Seeding energy totals for scenario #{scenario_id}..."
  import_large_csv(
    "#{Rails.root}/db/data/Energy/energyDetailed_#{scenario_id}.csv",
    'energy_totals(scenario_id, year, total, sector_id, fuel_type_id)'
  )

  # import ghg_emissions csvs
  puts "Seeding energy by end use totals for scenario #{scenario_id}..."
  import_large_csv(
    "#{Rails.root}/db/data/Energy/energyByEndUse_#{scenario_id}.csv",
    'energy_by_end_use_totals(scenario_id, year, total, end_use_id, fuel_type_id)'
  )  # import ghg_emissions csvs

  puts "Seeding energy for map totals for scenario #{scenario_id}..."
  import_large_csv(
    "#{Rails.root}/db/data/Energy/energyForMap_#{scenario_id}.csv",
    'energy_use_totals_by_zone_sector_fuel(scenario_id, zone_id, year, total, sector_id, fuel_type_id)'
  )

end

puts "Seeding emissions summaries..."
CSV.foreach("#{Rails.root}/db/data/Emissions/summaryData.csv", headers:true) do |row|
  EmissionsSummary.create(
    benchmark_type: row['ComparisonType'],
    scenario_id: row["scenarioID"],
    benchmark_year: row['time'],
    total_change_Mt: row["CO2eq_change_Mt"],
    per_capita_change_t: row["per_capita_change_tonnePerPerson"],
    percent_change: row["X._CO2eq_change"],
    percent_per_capita_change: row["X._per_capita_change"]
  )
end

puts "Seeding energy summaries..."
CSV.foreach("#{Rails.root}/db/data/Energy/summaryData.csv", headers:true) do |row|
  EnergySummary.create(
    benchmark_type: row['ComparisonType'],
    scenario_id: row["scenarioID"],
    benchmark_year: row['time'],
    total_use_change_PJ: row["EnergyUse_change_PJ"],
    per_capita_use_change_GJ: row["per_capita_change_GJPerPerson"],
    percent_use_change: row["X._EnergyUse_change"],
    percent_use_per_capita_change: row["X._per_capita_change"]
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