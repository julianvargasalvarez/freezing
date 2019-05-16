require 'rails_helper'

RSpec.describe ReadingSaverJob, type: :job do
  it "call the model to create the reading" do
    thermostat = FactoryBot.create(:thermostat, household_token: 'abc', location: 'Mitte')
    described_class.perform_now({ "household_token" => 'abc', "temperature" => "17.1", "humidity" => "70.3", "battery_charge" => "50.5", "number" => 1 })

    # Checks that the reading record has the proper values sent in the request
    last_reading = Reading.last
    expect(last_reading.number).to eq(1)
    expect(last_reading.thermostat).to eq(thermostat)
    expect(last_reading.temperature).to eq(17.1)
    expect(last_reading.humidity).to eq(70.3)
    expect(last_reading.battery_charge).to eq(50.5)
  end
end
