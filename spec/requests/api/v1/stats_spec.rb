require 'rails_helper'

RSpec.describe "Stats API", :type => :request do
  it 'returns a json with the statistics for the given househould_token' do
    thermostat = Thermostat.create(household_token: 'abc')
    ReadingCreator.new({ "household_token" => 'abc', "temperature" => "17.0", "humidity" => "70.0", "battery_charge" => "49.0" }).create

    get api_v1_stats_path, params: { household_token: 'abc' }

    result = JSON.parse(response.body)
    expect(result).to match({"temperature"    => {"min"=>17.0, "max"=>17.0, "avg"=>17.0},
                             "humidity"       => {"min"=>70.0, "max"=>70.0, "avg"=>70.0},
                             "battery_charge" => {"min"=>49.0, "max"=>49.0, "avg"=>49.0}
                            })
  end
end
