class GhgEmissionTotalsController < ApplicationController

  def index
  end

  def sector
  end

  def sector_bar
  end

  def data
    render json: GhgEmission.grouped_totals(:year, :scenario_id)
  end

end