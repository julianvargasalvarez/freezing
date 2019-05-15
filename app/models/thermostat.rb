class Thermostat < ApplicationRecord
  include Redis::Objects
  has_many :readings
  counter :total_measures
  hash_key :stats
end
