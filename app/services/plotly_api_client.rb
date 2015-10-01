class PlotlyApiClient

  def initialize(plotly_user, api_key)
    @un = plotly_user
    @api_key = api_key
    @client = PlotLy.new(@un, @api_key)
  end

  def create_plot(data, args)
    @client.plot(data, args) {|response| response }
  end

  def update_plot_layout

  end

  def update_plot_style

  end

end