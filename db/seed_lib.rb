def import_large_csv(file, table_col_mapping)
  # Setup raw connection
  conn = ActiveRecord::Base.connection
  rc = conn.raw_connection
  rc.exec("COPY #{table_col_mapping} FROM STDIN WITH CSV header")

  file = File.open(file, 'r')
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
    scenario_independent: ['emissions_total', 'energy_totals']
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
    ],
    end_use: [
      '#9edae5',
      '#17becf',
      '#dbdb8d',
      '#bcbd22',
      '#c7c7c7',
      '#7f7f7f',
      '#f7b6d2',
      '#e377c2',
      '#c49c94',
      '#8c564b'
    ]
  }
end