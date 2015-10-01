class PlotlyChartBuilder < ClassyEnum::Base

  def args
    {x: [], y: []}
  end

  def kwargs
    {
      filename: 'A Chart Looking for a Name',
      fileopt: 'new'
    }
  end

  def create_chart
    plotly_client.create_plot(args, kwargs)
  end

  def plotly_client
    @client ||= PlotlyApiClient.new(plotly_username, plotly_api_key)
  end

  def plotly_username
    'le0nL'
  end

  def plotly_api_key
    '0f25z3g85v'
  end

end

Dir[File.join(Rails.root, 'app', 'enums', 'plotly_chart_builder', '*.rb')].each{ |file| require_dependency file }
