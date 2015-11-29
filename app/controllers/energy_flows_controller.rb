class EnergyFlowsController < ApplicationController

  def index
    render
  end

  def theme_title
    'Energy Flow Sankey'
  end

  def sankey_data
    respond_to do |format|
      format.json do
        totals = EnergyFlowTotalSerializer.for_sankey(
          sankey_params[:scenario_id], sankey_params[:year]
        )
        render json: totals
      end
    end
  end

private

  def sankey_params
    s_params = params.require(:sankey_params).permit(:year, :scenario_id)
    s_params[:year] = s_params[:year].to_i
    s_params[:scenario_id] = s_params[:scenario_id].to_i
    return s_params
  end
end