class  Api::V1::StatsController < ApplicationController
  def index
    render json: JSON.parse($redis.get(params["household_token"])), status: :ok
  end
end
