class EnergyController < ApplicationController
  helper_method :all_zone_totals_90th_percentile, :sectors, :sectors_for_choropleth, :fuel_types, :fuel_types_for_choropleth

  def index
    @total_chart = PlotlyChart.named('energy_totals').first
    @by_sector_charts = PlotlyChart.named('energy_by_sector')
    @by_fuel_type_charts = PlotlyChart.named('energy_by_fuel_type')
    @by_end_use_charts = PlotlyChart.named('energy_by_end_use')
    @energy_summaries = EnergySummary.includes(:scenario)
    render
  end

  def choropleth_data
    respond_to do |format|
      format.json do
        totals = ::GeoJSON::CensusTract.
          with_energy_totals_where_year_scenario(
            choropleth_params[:year], choropleth_params[:scenario_id],
            choropleth_query_where_clause
          )
        render json: totals
      end
    end
  end

  def theme_title
    'Energy'
  end

  def all_zone_totals_90th_percentile
    records = EnergyUseTotalByZoneSectorFuel.descending_yearly_totals_by_zone_scenario_year
    decile_n = records.count / 10
    records[-decile_n].total.to_f
  end

  def sectors
    @sectors ||= begin
      sector_ids = EnergyTotal.pluck(:sector_id).uniq
      Sector.where(id: sector_ids)
    end
  end

  def fuel_types
    @fuel_types ||= begin
      fuel_type_ids = EnergyTotal.pluck(:fuel_type_id).uniq
      FuelType.where(id: fuel_type_ids)
    end
  end

  def sectors_for_choropleth
    @sectors_for_choropleth ||= begin
      sector_ids = EnergyUseTotalByZoneSectorFuel.pluck(:sector_id).uniq
      sectors = Sector.where(id: sector_ids)
      sectors.reject{|s| s.name == 'Transportation'}
    end
  end

  def fuel_types_for_choropleth
    @fuel_types_for_choropleth ||= begin
      fuel_type_ids = EnergyUseTotalByZoneSectorFuel.pluck(:fuel_type_id).uniq
      fuel_types = FuelType.where(id: fuel_type_ids)
      fuel_types.reject{|ft| ["Solar", "Water", "Wind"].include? ft.name}
    end
  end

private

  def choropleth_query_where_clause
    clause = {}
    unless choropleth_params[:sector_ids].include? "0"
      clause[:sector_id] = choropleth_params[:sector_ids].reject(&:blank?).map(&:to_i)
    end
    unless choropleth_params[:fuel_type_ids].include? "0"
      clause[:fuel_type_id] = choropleth_params[:fuel_type_ids].reject(&:blank?).map(&:to_i)
    end
    clause
  end

  def choropleth_params
    c_params = params.require(:choropleth_params).permit(
                :year, :scenario_id,
                {sector_ids: [], fuel_type_ids: []}
              )
    c_params[:year] = c_params[:year].to_i
    c_params[:scenario_id] = c_params[:scenario_id].to_i
    return c_params
  end

end