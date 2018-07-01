require 'sinatra'
require 'securerandom'

INSTANCE_ID = SecureRandom.uuid

get "/" do
  "Running on #{INSTANCE_ID}"
end

get '/health' do
  status 200
  "Healthy"
end
