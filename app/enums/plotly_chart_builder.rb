class PlotlyChartBuilder < ClassyEnum::Base

# Plotly API arguments

  def args
    {x: [], y: []}
  end

  def kwargs
    {
      filename: filename,
      fileopt: 'new'
    }
  end

# PlotlyChart model definitions

  def chart_type
    nil
  end

  def scenario_specific
    TRUE
  end

# Plotly client interface

  def plotly_client
    @client ||= PlotlyApiClient.new(plotly_username, plotly_api_key)
  end

  def plotly_username
    'le0nL'
  end

  def plotly_api_key
    '0f25z3g85v'
  end

  def create_chart
    response = plotly_client.create_plot(args, kwargs)
    {
      plotly_user: plotly_username,
      plotly_id: parse_chart_id_from_plotly_url(response['url']),
      chart_type: chart_type
    }
  end

  def filename
    "GHGProof #{organization_name} #{klass_name} #{chart_type.to_s}_chart #{scenario_name}"
  end

  def organization_name
    'demo_org'
  end

# Utility methods

  def parse_chart_id_from_plotly_url(url)
    URI(url).path.split('/').last
  end

  def klass_name
    self.class.name.split('::').last.underscore
  end

  def scenario_id
    owner.scenario_id
  end

  def scenario_name
    scenario_id ? "S#{scenario_id}" : ""
  end

end

Dir[File.join(Rails.root, 'app', 'enums', 'plotly_chart_builder', '*.rb')].each{ |file| require_dependency file }
