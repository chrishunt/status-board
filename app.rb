require 'sinatra'

require_relative 'lib/status_board/libsyn'
require_relative 'lib/status_board/chartbeat'

CHARTBEAT_API_KEY = ENV['CHARTBEAT_API_KEY']
CHARTBEAT_DOMAIN  = ENV['CHARTBEAT_DOMAIN']

get '/chartbeat/visitors' do
  content_type 'application/json'
  StatusBoard::Chartbeat.new(CHARTBEAT_API_KEY, CHARTBEAT_DOMAIN).visitors
end

get '/chartbeat/summary' do
  StatusBoard::Chartbeat.new(CHARTBEAT_API_KEY, CHARTBEAT_DOMAIN).summary
end
