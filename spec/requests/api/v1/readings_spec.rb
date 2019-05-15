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


3. GET Stats: gives the average, minimum and maximum by temperature, humidity and
battery_charge in a particular thermostat across all the period of time. Again, make sure this
method is consistent in the same way as method 2. For extra points, make it execute in O(1) time.


For simplicity, you can seed the DB with different thermostats containing household tokens and
locations. Make sure your code is properly tested with RSpec as well. You can use any tools and
gems to build and optimize your API. For extra points, handle bad requests with a JSON error
message and a non success response code.
=end

describe "Readings API", :type => :request do

  context "When the api receives a POST request from a thermostat" do
    it 'returns a json containing the sequence number for the given houshold' do
      FactoryBot.create(:thermostat, household_token: 'abc', location: 'Mitte')

      post api_v1_readings_path, params: { household_token: 'abc', temperature: 17.1, humidity: 70.3, battery_charge: 50.5 }

      result = JSON.parse(response.body)
      expect(result["number"]).to eq(1)
    end
  end

  context "When the api receives a GET request from a thermostat" do
    it 'returns a json containing the reading record for the given reading_id and household_token' do
      thermostat = FactoryBot.create(:thermostat, household_token: 'abc', location: 'Mitte')
      FactoryBot.create(:reading, thermostat: thermostat, temperature: 17.1, humidity: 70.3, battery_charge: 50.5, number: 1)

      get '/api/v1/readings', params: { household_token: 'abc', reading_id: 1 }

      response = JSON.parse(response.body)
      expect(response).to match({ temperature: 17.1, humidity: 70.3, battery_charge: 50.5 })
    end
  end
end
