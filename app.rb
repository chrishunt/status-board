require 'sinatra'

require_relative 'lib/status_board/libsyn'
require_relative 'lib/status_board/chartbeat'

CHARTBEAT_API_KEY = ENV['CHARTBEAT_API_KEY']
CHARTBEAT_DOMAIN  = ENV['CHARTBEAT_DOMAIN']

LIBSYN_EMAIL    = ENV['LIBSYN_EMAIL']
LIBSYN_PASSWORD = ENV['LIBSYN_PASSWORD']
LIBSYN_SHOW_ID  = ENV['LIBSYN_SHOW_ID']

get '/' do
  "good."
end

get '/chartbeat/visitors' do
  content_type 'application/json'
  StatusBoard::Chartbeat.new(CHARTBEAT_API_KEY, CHARTBEAT_DOMAIN).visitors
end

get '/chartbeat/summary' do
  StatusBoard::Chartbeat.new(CHARTBEAT_API_KEY, CHARTBEAT_DOMAIN).summary
end

get '/libsyn/recent' do
  content_type 'application/json'
  libsyn = StatusBoard::Libsyn.new \
    LIBSYN_EMAIL, LIBSYN_PASSWORD, LIBSYN_SHOW_ID
  libsyn.get
  libsyn.recent
end
