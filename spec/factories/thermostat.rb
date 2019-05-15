FactoryBot.define do
  factory :thermostat do
    household_token { "abcd" }
    location { "Somewhere" }
  end
end
