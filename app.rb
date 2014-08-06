require 'sinatra'

require_relative 'lib/status_board/libsyn'
require_relative 'lib/status_board/chartbeat'

get '/' do
  "Hello World!"
end
