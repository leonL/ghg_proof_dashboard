class PlotlyChartBuilder::EnergyByEndUse < PlotlyChartBuilder::EnergyByFactor

  def self.yearly_energy_use_grouped_by_scenario
    @use_by_scenario ||= begin
      EnergyByEndUseTotal.yearly_totals_by_factors([factor_symbol, :scenario]).
        group_by(&:scenario_id)
    end
  end

end