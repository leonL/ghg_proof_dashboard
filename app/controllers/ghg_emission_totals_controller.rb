class GhgEmissionTotalsController < ApplicationController

  def index
  end

  def data
    render json: GhgEmission.totals_for_year_for_scenario
  end

end