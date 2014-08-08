require 'sinatra'
require 'sinatra/namespace'

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
  'good.'
end

namespace '/chartbeat' do
  get '/visitors' do
    content_type 'application/json'
    chartbeat.visitors
  end

  get '/historical' do
    content_type 'application/json'
    chartbeat.historical
  end

  get '/summary' do
    chartbeat.summary
  end
end

namespace '/libsyn' do
  get '/recent' do
    content_type 'application/json'
    libsyn.recent
  end

  get '/totals' do
    content_type 'application/json'
    libsyn.totals
  end

  get '/history' do
    content_type 'application/json'
    libsyn.history
  end

  get '/today' do
    content_type 'application/json'
    libsyn.today
  end
end
