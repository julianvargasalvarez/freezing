FactoryBot.define do
  factory :reading do
    sequence(:number) { |n| n }
    temperature { 10.0 }
    humidity { 50.0 }
    battery_charge { 50.0 }
    thermostat
  end
end
