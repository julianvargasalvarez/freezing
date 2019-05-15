class CreateReadings < ActiveRecord::Migration[5.2]
  def change
    create_table :readings do |t|
      t.references :thermostat, foreign_key: true
      t.decimal :temperature
      t.decimal :humidity
      t.decimal :battery_charge
      t.bigint :number
      t.timestamp
    end
  end
end
