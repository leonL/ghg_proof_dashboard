class PlotlyChartBuilder < ClassyEnum::Base

  def create_chart
    response = plotly_client.create_plot(args, kwargs)
    {
      plotly_user: plotly_username,
      plotly_id: parse_chart_id_from_plotly_url(response['url']),
      chart_type: chart_type
    }
  end

  def chart_type
    :line
  end

  def args
    {x: [], y: []}
  end

  def kwargs
    {
      filename: filename,
      fileopt: 'new'
    }
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

  def filename
    'A Chart Looking for a Name'
  end

  def parse_chart_id_from_plotly_url(url)
    URI(url).path.split('/').last
  end

end

Dir[File.join(Rails.root, 'app', 'enums', 'plotly_chart_builder', '*.rb')].each{ |file| require_dependency file }
