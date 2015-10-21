class GhgEmission < ActiveRecord::Base

  belongs_to :scenario
  belongs_to :fuel_type
  belongs_to :sector
  belongs_to :zone, class_name: 'CensusTract', foreign_key: :zone_id, inverse_of: :ghg_emissions

  def self.yearly_totals_by_factors(factors=[], where_vals={})
    query = yearly_totals_by_factors_query(factors, where_vals)
    records = find_by_sql(query)
    preloader.preload(records, factors)
    records
  end

  def self.yearly_totals_by_factors_query(factors=[], where_vals={})
    factor_cols = factors.map{|col_name| t["#{col_name}_id"]}
    factor_cols.unshift t[:year]

    query = t.project(factor_cols, t[:total_emissions].sum.as('total')).
      group(factor_cols).
      order(factor_cols)

    where_vals.each do |col_name, val|
      query = query.where(t[col_name].eq(val))
    end
    query
  end

private

  def self.t
    arel_table
  end

  def self.preloader
    ActiveRecord::Associations::Preloader.new
  end
end