require 'rails_helper'

RSpec.describe StatsCalculator do
  it "returns the historical statistics for the given household_token" do
    thermostat = Thermostat.create(household_token: 'abc')

    ReadingCreator.new({ "household_token" => 'abc', "temperature" => "17.0", "humidity" => "70.0", "battery_charge" => "49.0" }).create
    ReadingCreator.new({ "household_token" => 'abc', "temperature" => "16.0", "humidity" => "90.0", "battery_charge" => "49.0" }).create
    ReadingCreator.new({ "household_token" => 'abc', "temperature" => "57.0", "humidity" => "98.0", "battery_charge" => "19.0" }).create

    result = described_class.new('abc').stats

    expect(result["temperature"]["min"]).to eq(16.0)
    expect(result["temperature"]["max"]).to eq(57.0)
    expect(result["temperature"]["avg"]).to eq(30.0)

    expect(result["humidity"]["min"]).to eq(70.0)
    expect(result["humidity"]["max"]).to eq(98.0)
    expect(result["humidity"]["avg"]).to eq(86.0)

    expect(result["battery_charge"]["min"]).to eq(19.0)
    expect(result["battery_charge"]["max"]).to eq(49.0)
    expect(result["battery_charge"]["avg"]).to eq(39.0)
  end
end
