require 'net/http'
require 'uri'
require 'json'

module StatusBoard
  class Chartbeat
    attr_reader :api_key, :domain

    HOST = 'api.chartbeat.com'

    def initialize(api_key, domain)
      @api_key = api_key
      @domain = domain
    end

    def summary
      path = "/live/recent/v3/?apikey=#{api_key}&host=#{domain}"
      resp, data = http.get(path)
      visitors = JSON.parse(resp.body)

      result = "<table>"

      visitors.each do |visitor|
        result << "<tr>"
        result << "<td style='width:40px'>#{visitor['country']}</td>"
        result << "<td>#{visitor['title'].split('|').first.strip}</td>"
        result << "</tr>"
      end

      result << "</table>"
    end

    private

    def http
      Net::HTTP.new HOST
    end
  end
end
