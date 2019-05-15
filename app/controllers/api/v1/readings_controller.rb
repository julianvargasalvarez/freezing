class Api::V1::ReadingsController < ApplicationController
  def create
    result = ReadingCreator.new(reading_params).create
    render json: result, status: :created
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
