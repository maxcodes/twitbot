require "dotenv/load"

# Set timezone for Mexico
require "active_support/time"
require "./scripts"
Time.zone = "America/Mexico_City"

loop do
  if Time.zone.now.day.odd?
    Scripts.follow_people!
  else
    Scripts.unfollow_people!
  end
  sleep_time = rand(200..300)
  puts "sleeping for #{sleep_time.round(2)} seconds"
  sleep sleep_time
end
