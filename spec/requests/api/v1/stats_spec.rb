require 'rails_helper'

=begin

3. GET Stats: gives the average, minimum and maximum by temperature, humidity and
battery_charge in a particular thermostat across all the period of time. Again, make sure this
method is consistent in the same way as method 2. For extra points, make it execute in O(1) time.

=end
RSpec.describe "Stats API", :type => :request do
  it 'returns a json with the statistics for the given househould_token' do
    thermostat = FactoryBot.create(:thermostat, household_token: 'abc', location: 'Mitte')

    get api_v1_stats_path, params: { household_token: 'abc' }

    result = JSON.parse(response.body)
    expect(result).to match({"temperature" => {"min" => 0.0, "max" => "0.0", "avg" => 0.0},
                             "humidity" => {"min" => 0.0, "max" => "0.0", "avg" => 0.0},
                             "battery_charge" => {"min" => 0.0, "max" => "0.0", "avg" => 0.0}
                            })
  end
end
