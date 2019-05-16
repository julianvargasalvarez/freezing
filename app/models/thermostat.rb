class Thermostat < ApplicationRecord
  include Redis::Objects
  after_create :initialize_stats

  has_many :readings

  # These field are stored in Redis for performance
  counter :total_readings

  value :current_temperature
  value :min_temperature
  value :max_temperature
  value :sum_temperature

  value :current_humidity
  value :min_humidity
  value :max_humidity
  value :sum_humidity

  value :current_battery_charge
  value :min_battery_charge
  value :max_battery_charge
  value :sum_battery_charge

  private
  def initialize_stats
    self.current_temperature.value = 0.0
    self.min_temperature.value = 1000.0
    self.max_temperature.value =    0.0
    self.sum_temperature.value =    0.0

    self.current_humidity.value = 0.0
    self.min_humidity.value    = 1000.0
    self.max_humidity.value    =    0.0
    self.sum_humidity.value    =    0.0

    self.current_battery_charge.value = 0.0
    self.min_battery_charge.value = 1000.0
    self.max_battery_charge.value =    0.0
    self.sum_battery_charge.value =    0.0
  end
end
