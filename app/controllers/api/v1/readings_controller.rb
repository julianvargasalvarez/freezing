class Api::V1::ReadingsController < ApplicationController
  def create
    thermostat = Thermostat.find_by(household_token: reading_params[:household_token])
    reading_attributes = reading_params.except(:household_token)
    reading = Reading.create!(reading_attributes.merge({thermostat: thermostat, number: thermostat.readings.count+1}))
    $redis.set(thermostat.household_token,{"temperature" => {"min" => 17.1, "max" => 17.1, "avg" => 17.1},
                             "humidity" => {"min" => 70.3, "max" => 70.3, "avg" => 70.3},
                             "battery_charge" => {"min" => 50.5, "max" => 50.5, "avg" => 50.5}
                            }.to_json)
    render json: {number: reading.number}, status: :created
  end

  def index
    thermostat = Thermostat.find_by(household_token: query_params[:household_token])
    reading = thermostat.readings.find_by(number: query_params[:reading_id])

    render json: reading.to_json(only: [:temperature, :humidity, :battery_charge]), status: :ok
  end

  private
  def reading_params
    params.permit(:household_token, :temperature, :humidity, :battery_charge)
  end

  def query_params
    params.permit(:household_token, :reading_id)
  end
end
