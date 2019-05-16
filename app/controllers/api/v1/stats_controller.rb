class  Api::V1::StatsController < ApplicationController
  def index
    result = StatsCalculator.new(params["household_token"]).stats
    render json: result, status: :ok
  end
end
