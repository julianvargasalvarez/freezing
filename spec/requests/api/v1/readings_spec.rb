require 'rails_helper'

=begin

  Thermostat:
   ID
   household_token (text)
   location (address)
  
  Reading:
   ID
   thermostat_id (foreign key)
   number (sequence number for every household)
   temperature (float)
   humidity (float)
   battery_charge (float)

The API consists of 3 methods. In addition to its own parameters each method accepts a household
token to authenticate a thermostat. Serialize an HTTP response body using JSON. The methods are:

1. POST Reading: stores temperature, humidity and battery charge from a particular thermostat.
This method is going to have a very high request rate because many IoT thermostats are going to call
it very frequently and simultaneously. Make it as fast as possible and schedule a background job
for writing to the DB (you can use Sidekiq for example).
The method also returns a generated sequence number starting from 1 and every household has its own sequence. (this is tested in the model)

2. GET Reading: returns the thermostat data using the reading_id obtained from POST Reading. The
API must be consistent, that is if the method 1 returns, the thermostat data must be immediately
available from this method even if the background job is not yet finished.

For simplicity, you can seed the DB with different thermostats containing household tokens and
locations. Make sure your code is properly tested with RSpec as well. You can use any tools and
gems to build and optimize your API. For extra points, handle bad requests with a JSON error
message and a non success response code.

=end

RSpec.describe "Readings API", :type => :request do

  context "When the api receives a POST request from a thermostat" do
    it 'returns a json containing the sequence number for the given houshold' do
      thermostat = FactoryBot.create(:thermostat, household_token: 'abc', location: 'Mitte')

      post api_v1_readings_path, params: { "household_token" => 'abc', "temperature" => 17.1, "humidity" => 70.3, "battery_charge" => 50.5 }

      result = JSON.parse(response.body)

      # Checks for the endpoint to return the sequence number
      expect(result["number"]).to eq(1)

      # Checks that the reading record has the proper values sent in the request
      last_reading = Reading.last
      expect(last_reading.number).to eq(1)
      expect(last_reading.thermostat).to eq(thermostat)
      expect(last_reading.temperature).to eq(17.1)
      expect(last_reading.humidity).to eq(70.3)
      expect(last_reading.battery_charge).to eq(50.5)

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
