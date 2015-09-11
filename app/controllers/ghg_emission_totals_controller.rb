class GhgEmissionTotalsController < ApplicationController

  def index
  end

  def data
    render json: GhgEmission.for_json_totals_by_scenario_year_(params[:factor])
  end

end