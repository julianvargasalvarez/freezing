FactoryBot.define do
  factory :thermostat do
    household_token { "abcd" }
    locations { "Somewhere" }
  end
end
