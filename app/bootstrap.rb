# load the database connector
require "config/database"

# load the db module
require "config/db_connected"

# load all models
Dir.glob( "./app/models/**/*.rb" ) do |file|
  puts "Loading model: #{file}"
  require file
end

# load all controllers (and anything else)
Dir[ "./app/**/*.rb" ].reject { |f| f[ "/app/models" ] }.each do |file|
  puts "Loading file: #{file}"
  require file
end
