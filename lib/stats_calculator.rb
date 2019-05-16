class StatsCalculator
  attr_reader :household_token

  def initialize(household_token)
    @household_token = household_token
  end

  def stats
    # The three variables are sumed up as they are created thus here
    # we only have to divide the total of each variable by the total
    # number of readings, in consequence, regardles of the number of
    # readings, only one operation is performed to calculate the
    # averages O(1)

    thermostat = Thermostat.find_by(household_token: household_token)
    total_readings = thermostat.total_readings.to_f

    { "temperature" => {"min" => thermostat.min_temperature.value.to_f,
                        "max" => thermostat.max_temperature.value.to_f,
                        "avg" => thermostat.sum_temperature.value.to_f/total_readings},

      "humidity" => {"min" => thermostat.min_humidity.value.to_f,
                     "max" => thermostat.max_humidity.value.to_f,
                     "avg" => thermostat.sum_humidity.value.to_f/total_readings},

      "battery_charge" => {"min" => thermostat.min_battery_charge.to_f,
                           "max" => thermostat.max_battery_charge.to_f,
                           "avg" => thermostat.sum_battery_charge.to_f/total_readings}
    }
  end
end
