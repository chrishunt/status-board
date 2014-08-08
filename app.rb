require 'sinatra'

require_relative 'lib/status_board/config'
require_relative 'lib/status_board/libsyn'
require_relative 'lib/status_board/chartbeat'

def libsyn
  StatusBoard::Libsyn.new LIBSYN_EMAIL, LIBSYN_PASSWORD, LIBSYN_SHOW_ID
end

def chartbeat
  StatusBoard::Chartbeat.new CHARTBEAT_API_KEY, CHARTBEAT_DOMAIN
end

get '/' do
  "good."
end

get '/chartbeat/visitors' do
  content_type 'application/json'
  chartbeat.visitors
end

get '/chartbeat/historical' do
  content_type 'application/json'
  chartbeat.historical
end

get '/chartbeat/summary' do
  chartbeat.summary
end

get '/libsyn/recent' do
  content_type 'application/json'
  libsyn.recent
end

get '/libsyn/totals' do
  content_type 'application/json'
  libsyn.totals
end

get '/libsyn/history' do
  content_type 'application/json'
  libsyn.history
end

get '/libsyn/today' do
  content_type 'application/json'
  libsyn.today
end
