class ThemePresenter::EmissionsPresenter < ThemePresenter
  attr_accessor :plotly_chart_names

  def initialize
    self.plotly_chart_names = ['emissions_total', 'emissions_by_sector', 'emissions_by_fuel_type']
    load_plotly_charts *plotly_chart_names
  end

  def summary
    EmissionsSummary.all.group_by(&:benchmark_type).to_a
  end

  def unique_dimension_ids
    @dimension_ids ||= begin
      uniques = {fuel_type_ids: [], sector_ids: []}
      GhgEmission.select(:fuel_type_id, :sector_id).distinct.each do |e|
        uniques[:fuel_type_ids] << e.fuel_type_id
        uniques[:sector_ids] << e.sector_id
      end
      uniques[:fuel_type_ids].uniq!; uniques[:sector_ids].uniq!
      uniques
    end
  end

  def sectors
    @sectors ||= begin
      Sector.where(id: unique_dimension_ids[:sector_ids])
    end
  end

  def fuel_types
    @fuel_types ||= begin
      FuelType.where(id: unique_dimension_ids[:fuel_type_ids])
    end
  end

  def sectors_for_choropleth
    @all_sectors_but_transportation ||= sectors.reject{|s| s.name == 'Transportation'}
  end

  def fuel_types_for_choropleth
    fuel_types
  end

  def all_zone_totals_90th_percentile
    records = GhgEmission.descending_yearly_totals_by_zone_scenario_year
    decile_n = records.count / 10
    records[-decile_n].total.to_f
  end
end