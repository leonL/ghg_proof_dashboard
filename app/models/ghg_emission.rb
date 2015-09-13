class GhgEmission < ActiveRecord::Base

  def self.totals_for_year_for_scenario
    t = group(:scenario_id, :year).sum(:total_emissions)
    t = t.map do |t|
      {
        scenario: t.first.first,
        year: t.first.last,
        ghg_emissions: t.last
      }
    end
    t.sort_by{ |hsh| hsh[:year]}
  end

end