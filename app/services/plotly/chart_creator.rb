class Plotly::ChartCreator

  attr_reader :data

  def initialize
    @client = ::PlotLy.new('le0nL', '0f25z3g85v')
    @data = JSON.parse('[{"opacity":1,"showlegend":true,"error_x":{"color":"black","width":"2","copy_ystyle":true,"thickness":"1"},"name":"Business as Usual","yaxis":"y","text":null,"error_y":{"color":"black","width":"2","thickness":"1"},"xsrc":"le0nL:8:b1d550","visible":true,"mode":"lines","xaxis":"x","ysrc":"le0nL:8:149fe6","line":{"dash":"solid","color":"#1f77b4","shape":"linear","width":2},"fill":"none","type":"scatter","marker":{"color":"rgb(19, 27, 88)","symbol":"dot","line":{"color":"white","width":6},"size":6},"uid":"78f99b"},{"opacity":1,"showlegend":true,"error_x":{"color":"black","width":"2","copy_ystyle":true,"thickness":"1"},"name":"Scenario 1","yaxis":"y","text":null,"error_y":{"color":"black","width":"2","thickness":"1"},"xsrc":"le0nL:8:b1d550","visible":true,"mode":"lines","xaxis":"x","ysrc":"le0nL:8:1de243","line":{"dash":"solid","color":"#ff7f0e","shape":"linear","width":2},"fill":"none","type":"scatter","marker":{"color":"rgb(0, 167, 141)","symbol":"dot","line":{"color":"white","width":6},"size":6},"uid":"f4c1e6"},{"opacity":1,"showlegend":true,"error_x":{"color":"black","width":"2","copy_ystyle":true,"thickness":"1"},"name":"Scenario 2","yaxis":"y","text":null,"error_y":{"color":"black","width":"2","thickness":"1"},"xsrc":"le0nL:8:b1d550","marker":{"color":"rgb(252, 185, 37)","symbol":"dot","line":{"color":"white","width":6},"size":6},"mode":"lines","xaxis":"x","ysrc":"le0nL:8:f8afd2","line":{"dash":"solid","color":"#2ca02c","shape":"linear","width":2},"fill":"none","type":"scatter","uid":"165cea"}]')
    @layout = JSON.parse('{"autosize":true,"yaxis":{"showexponent":"all","showticklabels":true,"titlefont":{"color":"#444","family":"\"Open sans\", verdana, arial, sans-serif","size":14},"linecolor":"rgba(152, 0, 0, 0.5)","mirror":false,"nticks":0,"linewidth":1.5,"autorange":true,"tickmode":"auto","title":"Total Emissions (Mt)","ticks":"","rangemode":"normal","zeroline":true,"gridcolor":"#eee","type":"linear","zerolinewidth":1,"ticklen":6,"showline":false,"showgrid":true,"tickfont":{"color":"#444","family":"\"Open sans\", verdana, arial, sans-serif","size":12},"tickangle":"auto","gridwidth":1,"zerolinecolor":"#444","range":[61.27279940635456,87.25615970390945],"tickcolor":"rgba(0, 0, 0, 0)","exponentformat":"B"},"paper_bgcolor":"#fff","plot_bgcolor":"#fff","dragmode":"zoom","showlegend":true,"separators":".,","height":511,"width":1028,"legend":{"bordercolor":"black","yanchor":"top","xref":"paper","xanchor":"left","yref":"paper","bgcolor":"white","borderwidth":0,"y":1.049056603773585,"x":1.0296296296296297,"font":{"color":"rgb(105, 100, 124)","family":""}},"bargap":0.2,"titlefont":{"color":"#444","family":"\"Open sans\", verdana, arial, sans-serif","size":17},"xaxis":{"showexponent":"all","showticklabels":true,"titlefont":{"color":"#444","family":"\"Open sans\", verdana, arial, sans-serif","size":14},"linecolor":"rgba(152, 0, 0, 0.5)","mirror":false,"nticks":0,"linewidth":1.5,"autorange":true,"tickmode":"auto","title":"Year","ticks":"","rangemode":"normal","zeroline":true,"gridcolor":"#eee","type":"linear","zerolinewidth":1,"ticklen":6,"showline":false,"showgrid":true,"tickfont":{"color":"#444","family":"\"Open sans\", verdana, arial, sans-serif","size":12},"tickangle":"auto","gridwidth":1,"zerolinecolor":"#444","range":[2011,2050],"tickcolor":"rgba(0, 0, 0, 0)","exponentformat":"B"},"title":"Total Greenhouse Gas Emissions","hovermode":"x","font":{"color":"#444","family":"\"Open sans\", verdana, arial, sans-serif","size":12},"margin":{"r":10},"hidesources":false}')
  end

  def line1_coords
    years = []
    totals = []
    GhgEmission.for_scenario(0).grouped_totals(:year).map do |total|
      years << total[:year]
      totals << total[:ghg_emissions]
    end
    {x: years, y: totals}
  end

  def create_test
    doctored_data = @data
    doctored_data[0] = @data.first.merge(line1_coords)
    doctored_data[0].delete('xsrc')
    doctored_data[0].delete('ysrc')
    create(doctored_data, @layout)
  end

  def create(data, layout)
    url = ''
    @client.plot(data, layout) do |response|
      url = response['url']
    end
    url
  end

end