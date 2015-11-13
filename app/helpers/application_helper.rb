module ApplicationHelper

  def scenarios
    @scenarios ||= Scenario.includes(:colour)
  end

  def bau
    @bau ||= scenarios.find &:bau
  end

  def fuel_types
    @fuel_types ||= FuelType.all
  end

  def end_uses
    @end_uses ||= EndUse.all
  end

  def sectors
    @sectors ||= Sector.all
  end

  def c
    @config ||= Configuration.new
  end
end
