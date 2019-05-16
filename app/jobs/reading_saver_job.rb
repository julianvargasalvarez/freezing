class ReadingSaverJob < ApplicationJob
  queue_as :default

  def perform(reading_params)
    reading_attributes = reading_params.except("household_token")
    thermostat = Thermostat.find_by(household_token: reading_params["household_token"])
    thermostat.readings.create!(reading_attributes)
  end
end
