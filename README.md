# README

The projects uses Docker and Compose, to setup follow these steps:

```bash
sudo docker-compose run web bundle
sudo docker-compose run web bundle exec rails db:drop db:create db:migrate db:seed
```

To run the specs:
```bash
sudo docker-compose run web bundle exec rspec spec
```

To run the app in development mode:
```bash
sudo docker-compose up
```

To test each endpoint from the terminal:
```bash

# Creates a Reading entry
curl -XPOST -H "Content-Type: application/json" http://localhost:3000/api/v1/readings -d ' { "household_token": "abc-1", "temperature": "17.1", "humidity": "70.3", "battery_charge": "50.5" } '

# Retrieves a particular reading entry
curl -XGET -H "Content-Type: application/json" http://localhost:3000/api/v1/readings -d ' { "household_token": "abc-1", "reading_id":1 } '

# Retrieves the statistics for a given token
curl -XGET -H "Content-Type: application/json" http://localhost:3000/api/v1/stats -d ' { "household_token": "abc-1" } '
```

To perform a stress test of the api:
```bash
source dummy_data.sh
```
