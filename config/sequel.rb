require 'sequel'
DB = Sequel.sqlite("./db/#{ENV.fetch('Rack_Env', 'development')}.db")