require 'rails_helper'

RSpec.describe Thermostat, type: :model do
  it { should have_many(:readings) }
  it { should respond_to(:total_measures) }
  it { should respond_to(:stats) }
end
