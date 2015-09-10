class GhgEmissionTotalsController < ApplicationController

  def by_scenario_year_
    totals = GhgEmission.totals_by_scenario_year_(params[:factor])
    render json: totals
  end

end