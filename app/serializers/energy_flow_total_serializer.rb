class EnergyFlowTotalSerializer

  def self.for_sankey(scenario_id, year)
    records = EnergyFlowTotal.where(scenario_id: scenario_id, year: year)
    preloader.preload(records, [:source, :target])
    all_dimension_names = records.map{|r| r.target.name }.uniq |
                          records.map{|r| r.target.name }.uniq

    data = {}
    data[:nodes] = all_dimension_names.map{|d_name| {name: d_name}}
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