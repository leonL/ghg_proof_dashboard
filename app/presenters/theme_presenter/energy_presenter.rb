class ThemePresenter::EnergyPresenter < ThemePresenter
  attr_accessor :plotly_chart_names

  def initialize
    self.plotly_chart_names =
      ['energy_totals', 'energy_by_sector', 'energy_by_fuel_type', 'energy_by_end_use']
    load_plotly_charts *plotly_chart_names
  end

  def summary
    EnergySummary.all.group_by(&:benchmark_type).to_a
  end

  def unique_dimension_ids
    @dimension_ids ||= unique_dimension_ids_for_klass EnergyTotal
  end

  def unique_dimension_ids_for_choropleth
    @dimension_ids_for_choropleth ||= unique_dimension_ids_for_klass EnergyUseTotalByZoneSectorFuel
  end

  def sectors
    @sectors ||= begin
      puts unique_dimension_ids[:sector_ids]
      Sector.where(id: unique_dimension_ids[:sector_ids])
    end
  end

  def fuel_types
    @fuel_types ||= begin
      puts unique_dimension_ids[:fuel_type_ids]
      FuelType.where(id: unique_dimension_ids[:fuel_type_ids])
    end
  end

  def sectors_for_choropleth
    @sectors_for_choropleth ||= begin
      puts unique_dimension_ids_for_choropleth[:sector_ids]
      sectors = Sector.where(id: unique_dimension_ids_for_choropleth[:sector_ids])
      sectors.reject{|s| s.name == 'Transportation'}
    end
  end

  def fuel_types_for_choropleth
    @fuel_types_for_choropleth ||= begin
      puts unique_dimension_ids_for_choropleth[:fuel_type_ids]
      fuel_types = FuelType.where(id: unique_dimension_ids_for_choropleth[:fuel_type_ids])
      fuel_types.reject{|ft| ["Solar", "Water", "Wind"].include? ft.name}
    end
  end

  def all_zone_totals_90th_percentile
    records = EnergyUseTotalByZoneSectorFuel.descending_yearly_totals_by_zone_scenario_year
    decile_n = records.count / 10
    records[-decile_n].total.to_f
  end

private

  def unique_dimension_ids_for_klass(klass)
    uniques = {fuel_type_ids: [], sector_ids: []}
    klass.select(:fuel_type_id, :sector_id).distinct.each do |e|
      uniques[:fuel_type_ids] << e.fuel_type_id
      uniques[:sector_ids] << e.sector_id
    end
    uniques[:fuel_type_ids].uniq!; uniques[:sector_ids].uniq!
    uniques
  end

end