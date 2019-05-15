class Api::V1::ReadingsController < ApplicationController
  def create
    thermostat = Thermostat.find_by(household_token: reading_params[:household_token])
    reading_attributes = reading_params.except(:household_token)
    Reading.create!(reading_attributes.merge({thermostat: thermostat, number: thermostat.readings.count+1}))
    render json: {number: 1}, status: :created
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
