class Api::V1::ReadingsController < ApplicationController
  def create
    render json: {number: 1}, status: :created
  end
end
