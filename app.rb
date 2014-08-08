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
  get '/summary' do
    chartbeat.summary
  end

  %w[visitors historical].each do |action|
    get "/#{action}" do
      content_type 'application/json'
      chartbeat.send action
    end
  end
end

namespace '/libsyn' do
  %w[recent totals history today].each do |action|
    get "/#{action}" do
      content_type 'application/json'
      libsyn.send action
    end
  end
end
