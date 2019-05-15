require 'rails_helper'

RSpec.describe ReadingCreator do
  it "returns a hash with the current reading" do
    thermostat = Thermostat.create(household_token: 'abc')
    result = described_class.new({ "household_token" => 'abc', "temperature" => 17.1, "humidity" => 70.3, "battery_charge" => 50.5 }).create
    expect(result).to match( {number: 1} )
  end

  it "increases the counter on each creation" do
    thermostat = Thermostat.create(household_token: 'abc')

    described_class.new({ "household_token" => 'abc', "temperature" => "17.1", "humidity" => "70.4", "battery_charge" => "49.0" }).create
    described_class.new({ "household_token" => 'abc', "temperature" => "17.2", "humidity" => "70.5", "battery_charge" => "49.0" }).create
    result = described_class.new({ "household_token" => 'abc', "temperature" => "17.3", "humidity" => "70.6", "battery_charge" => "48.9" }).create

    expect(result).to match( {number: 3} )
  end

  it "keeps track of the last reading received" do
    thermostat = Thermostat.create(household_token: 'abc')

    described_class.new({ "household_token" => 'abc', "temperature" => "17.1", "humidity" => "70.4", "battery_charge" => "49.0" }).create
    described_class.new({ "household_token" => 'abc', "temperature" => "17.0", "humidity" => "70.5", "battery_charge" => "49.0" }).create
    described_class.new({ "household_token" => 'abc', "temperature" => "57.3", "humidity" => "90.6", "battery_charge" => "18.9" }).create

    expect(thermostat.current_temperature.value).to eq("57.3")
    expect(thermostat.current_humidity.value).to eq("90.6")
    expect(thermostat.current_battery_charge.value).to eq("18.9")

    expect(thermostat.min_temperature.value).to eq("17.0")
    expect(thermostat.max_temperature.value).to eq("57.3")
    expect(thermostat.sum_temperature.value).to eq("91.4")

    expect(thermostat.min_humidity.value).to eq("70.4")
    expect(thermostat.max_humidity.value).to eq("90.6")
    expect(thermostat.sum_humidity.value).to eq("231.5")

    expect(thermostat.min_battery_charge.value).to eq("18.9")
    expect(thermostat.max_battery_charge.value).to eq("49.0")
    expect(thermostat.sum_battery_charge.value).to eq("116.9")
  end
end
