class Emissions::ChartsController < ApplicationController

  def total # params: scenario_ids
    respond_to do |format|
      format.json do
      end

      format.html do
        @plotly_chart = PlotlyChart.named('total_emissions')
        render
      end
    end
  end

  def by_sector

  end

  def by_fuel

  end

  def data
    render json: GhgEmission.grouped_totals(:year, :scenario_id)
  end

end