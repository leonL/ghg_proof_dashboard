class EnergyFlowTotalSerializer

  def self.for_sankey(scenario_id, year)
    records = EnergyFlowTotal.where(scenario_id: scenario_id, year: year)
    preloader.preload(records, [{source: [:colour]}, {target: [:colour]}])
    all_dimensions = records.map{|r| [r.source.name, r.source.colour.hex] } |
                    records.map{|r| [r.target.name, r.target.colour.hex] }
    all_unqiue_dimensions = all_dimensions.uniq &:first
    all_dimension_names = all_unqiue_dimensions.map &:first

    data = {}
    data[:nodes] = all_unqiue_dimensions.map do |d|
      {
        name: d.first,
        colour: d.last
      }
    end
    data[:links] = records.map do |record|
      {
        source: all_dimension_names.find_index(record.source.name),
        target: all_dimension_names.find_index(record.target.name),
        value: record.total.to_f.round(2)
      }
    end
    data.to_json
  end

private

  def self.preloader
    ActiveRecord::Associations::Preloader.new
  end

end