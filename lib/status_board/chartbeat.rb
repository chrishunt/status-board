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
      stats = JSON.parse(resp.body)

      result = "<table>"

      stats.each do |visitor|
        result << "<tr>"
        result << "<td style='width:40px'>"
        result << "<img src='flags/#{visitor['country'].downcase}.png'>"
        result << "</td>"
        result << "<td>#{visitor['title'].split('|').first.strip}</td>"
        result << "</tr>"
      end

      result << "</table>"
    end

    def visitors
      path = "/live/quickstats/v3/?apikey=#{api_key}&host=#{domain}"
      resp, data = http.get(path)
      stats = JSON.parse(resp.body)

      {
        "graph" => {
          "title" => "Visitors",
          "refreshEveryNSeconds" => 10,
          "datasequences" => [{
            "title" => "healthyhacker.com",
            "datapoints" => [
              { "title" => "visitors", "value" => stats["people"] }
            ]
          }]
        }
      }.to_json
    end

    private

    def http
      Net::HTTP.new HOST
    end
  end
end
