class ReadingCreator
  attr_reader :reading_params

  def initialize(reading_params)
    @reading_params = reading_params
  end

  def create
    reading_attributes = reading_params.except("household_token")

    thermostat = Thermostat.find_by(household_token: reading_params["household_token"])
    thermostat.total_readings.increment

    household_token, temperature, humidity, battery_charge = reading_params.slice("household_token", "temperature", "humidity", "battery_charge").values.map(&:to_f)

    thermostat.current_temperature.value = temperature
    thermostat.min_temperature.value = [thermostat.min_temperature.value.to_f, temperature].min
    thermostat.max_temperature.value = [thermostat.max_temperature.value.to_f, temperature].max
    thermostat.sum_temperature.value = thermostat.sum_temperature.value.to_f + temperature

    thermostat.current_humidity.value = humidity
    thermostat.min_humidity.value = [thermostat.min_humidity.to_f, humidity].min
    thermostat.max_humidity.value = [thermostat.max_humidity.to_f, humidity].max
    thermostat.sum_humidity.value = thermostat.sum_humidity.to_f + humidity

    thermostat.current_battery_charge.value = battery_charge
    thermostat.min_battery_charge.value = [thermostat.min_battery_charge.value.to_f, battery_charge].min
    thermostat.max_battery_charge.value = [thermostat.max_battery_charge.value.to_f, battery_charge].max
    thermostat.sum_battery_charge.value = thermostat.sum_battery_charge.value.to_f + battery_charge

    # This one goes to the background job
    thermostat.readings.create!(reading_attributes.merge({number: thermostat.total_readings.value.to_i}))

    {number: thermostat.total_readings.value}
  end
end
