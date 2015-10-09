class PlotlyChartBuilder < ClassyEnum::Base

  def create_chart
    response = plotly_client.create_plot(args, kwargs)
    {
      plotly_user: plotly_username,
      plotly_id: parse_chart_id_from_plotly_url(response['url'])
    }
  end

# default arguments

  def kwargs
    {
      filename: filename,
      fileopt: 'new' # this is probably handled by the gem, dependent on what method is called, no?
    }
  end

# Plotly client interface (this should all be moved out of this class - into a module perhaps)

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
    name = "GHGProof #{self.class.name_snake_case.titleize} Chart;"
    name += " Scenario – #{scenario.name};" unless scenario.blank?
    name += " Org – #{organization_name};" unless scenario.blank?
    name += " Rails Env – #{RAILS_ENV}"
    name
  end

  def organization_name
    'Municipality X'
  end

# Utility methods

  def parse_chart_id_from_plotly_url(url)
    URI(url).path.split('/').last
  end

  def self.name_snake_case
    name.split('::').last.underscore
  end

  delegate :scenario_id, :scenario, to: :owner
end

Dir[File.join(Rails.root, 'app', 'enums', 'plotly_chart_builder', '*.rb')].each{ |file| require_dependency file }
