require 'rails_helper'

RSpec.describe "Readings API", :type => :request do

  context "When the api receives a POST request from a thermostat" do
    it 'returns a json containing the sequence number for the given houshold' do
      thermostat = FactoryBot.create(:thermostat, household_token: 'abc', location: 'Mitte')

      expect(ReadingSaverJob).to receive(:perform_later).with({ "household_token" => 'abc', "temperature" => "17.1", "humidity" => "70.3", "battery_charge" => "50.5", "number" => 1 })

      post api_v1_readings_path, params: { "household_token" => 'abc', "temperature" => 17.1, "humidity" => 70.3, "battery_charge" => 50.5 }

      result = JSON.parse(response.body)

      # Checks for the endpoint to return the sequence number
      expect(result["number"]).to eq(1)

      # Checks the statistics are calculated for the request sent
      thermostat.reload
      expect(thermostat.total_readings.value).to eq(1)

      expect(thermostat.current_temperature.value).to eq("17.1")
      expect(thermostat.min_temperature.value).to eq("17.1")
      expect(thermostat.max_temperature.value).to eq("17.1")
      expect(thermostat.sum_temperature.value).to eq("17.1")

      expect(thermostat.current_humidity.value).to eq("70.3")
      expect(thermostat.max_humidity.value).to eq("70.3")
      expect(thermostat.sum_humidity.value).to eq("70.3")

      expect(thermostat.current_battery_charge.value).to eq("50.5")
      expect(thermostat.max_battery_charge.value).to eq("50.5")
      expect(thermostat.sum_battery_charge.value).to eq("50.5")
    end
  end

  context "When the api receives a GET request from a thermostat" do
    it 'returns a json containing the reading record for the given reading_id and household_token' do
      thermostat = FactoryBot.create(:thermostat, household_token: 'abc', location: 'Mitte')
      FactoryBot.create(:reading, thermostat: thermostat, temperature: 17.1, humidity: 70.3, battery_charge: 50.5, number: 1)
      FactoryBot.create(:reading, thermostat: thermostat, temperature: 17.2, humidity: 71.3, battery_charge: 50.0, number: 2)

      get api_v1_readings_path, params: { household_token: 'abc', reading_id: 1 }

      result = JSON.parse(response.body)

      # Checks the endpoint returs the record sepecified b the reading_id sent in the request
      expect(result).to match({ "temperature" => "17.1", "humidity" => "70.3", "battery_charge" => "50.5" })
    end
  end
end
