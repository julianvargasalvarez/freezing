class Api::V1::ReadingsController < ApplicationController
  def create
    render json: {number: 1}, status: :created
  end

  def index
    render json: Reading.all.to_json(only: [:temperature, :humidity, :battery_charge]), status: :ok
  end
end
