require 'sinatra'
require 'sinatra/namespace'

require_relative 'lib/status_board/config'
require_relative 'lib/status_board/libsyn'
require_relative 'lib/status_board/chartbeat'

def libsyn
  StatusBoard::Libsyn.new LIBSYN_EMAIL, LIBSYN_PASSWORD, LIBSYN_SHOW_ID
end

def chartbeat(host)
  StatusBoard::Chartbeat.new CHARTBEAT_API_KEY, host
end

get '/' do
  'good.'
end

namespace '/chartbeat' do
  get '/summary/:host' do
    chartbeat(params[:host]).summary
  end

  %w[visitors historical].each do |action|
    get "/#{action}/:host" do
      content_type 'application/json'
      chartbeat(params[:host]).send action
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
