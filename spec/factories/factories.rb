FactoryGirl.define do

  factory :ghg_emission do
    total_emissions { BigDecimal(Faker::Number.decimal(0, 21)) }
  end

end