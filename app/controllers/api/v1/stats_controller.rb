class  Api::V1::StatsController < ApplicationController
  def index
    render json: {"temperature" => {"min" => 0.0, "max" => "0.0", "avg" => 0.0},
                             "humidity" => {"min" => 0.0, "max" => "0.0", "avg" => 0.0},
                             "battery_charge" => {"min" => 0.0, "max" => "0.0", "avg" => 0.0}
                            }, status: :ok
  end
end
