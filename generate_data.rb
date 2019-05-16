tokens = ['abc-1', 'abc-2', 'abc-3']


# Creates 10.000 requests to send data to the api
open('dummy_data.sh', 'w') do |f|
  10_000.times do
    household_token = tokens.sample(1).first
    temperature = rand(1.0..100.0).round(2)
    humidity = rand(1.0..100.0).round(2)
    battery_charge = rand(1.0..100.0).round(2)
  
    f.puts "curl -XPOST -H \"Content-Type: application/json\" http://localhost:3000/api/v1/readings -d ' { \"household_token\": \"#{household_token}\", \"temperature\": \"#{temperature}\", \"humidity\": \"#{humidity}\", \"battery_charge\": \"#{battery_charge}\" } ' &"
  end
end
