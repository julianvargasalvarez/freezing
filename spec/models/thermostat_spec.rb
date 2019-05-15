require 'rails_helper'

RSpec.describe Thermostat, type: :model do
  it { should have_many(:readings) }
  it { should respond_to(:total_readings) }
  it { should respond_to(:current_temperature ) }
  it { should respond_to(:min_temperature) }
  it { should respond_to(:max_temperature) }
  it { should respond_to(:sum_temperature) }

  it { should respond_to(:current_humidity) }
  it { should respond_to(:min_humidity) }
  it { should respond_to(:max_humidity) }
  it { should respond_to(:sum_humidity) }

  it { should respond_to(:current_battery_charge) }
  it { should respond_to(:min_battery_charge) }
  it { should respond_to(:max_battery_charge) }
  it { should respond_to(:sum_battery_charge) }

  it "Initalizes the statistics after the record is created" do
    subject.household_token = 'abc'
    subject.save
    expect(subject.total_readings.value).to eq(0)

    expect(subject.current_temperature.value).to eq("0.0")
    expect(subject.min_temperature.value).to eq("1000.0")
    expect(subject.max_temperature.value).to eq("0.0")
    expect(subject.sum_temperature.value).to eq("0.0")

    expect(subject.current_humidity.value).to eq("0.0")
    expect(subject.min_humidity.value).to eq("1000.0")
    expect(subject.max_humidity.value).to eq("0.0")
    expect(subject.sum_humidity.value).to eq("0.0")

    expect(subject.current_battery_charge.value).to eq("0.0")
    expect(subject.min_battery_charge.value).to eq("1000.0")
    expect(subject.max_battery_charge.value).to eq("0.0")
    expect(subject.sum_battery_charge.value).to eq("0.0")
  end
end
