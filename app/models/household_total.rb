class HouseholdTotal < ActiveRecord::Base

  def self.yearly_totals_by_factors(factors=[], where_vals={})
    query = yearly_totals_by_factors_query(factors, where_vals)
    records = find_by_sql(query)
    preloader.preload(records, factors)
    records
  end

  def self.yearly_totals_by_factors_query(factors=[], where_vals={}, order_by_total=false)
    factor_cols = factors.map{|col_name| t["#{col_name}_id"]}
    factor_cols.unshift t[:year]

    order_cols = order_by_total ? 'total' : factor_cols

    query = t.project(factor_cols, t[:total].sum.as('total')).
      group(factor_cols).
      order(order_cols)

    where_vals.each do |col_name, val|
      query = val.is_a?(Array) ? query.where(t[col_name].in(val)) : query.where(t[col_name].eq(val))
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