require 'net/http'
require 'uri'
require 'json'
require 'time'

module StatusBoard
  class Chartbeat
    attr_reader :api_key, :domain

    HOST = 'api.chartbeat.com'

    def initialize(api_key, domain)
      @api_key = api_key
      @domain = domain
    end

    def summary
      stats = get "/live/recent/v3/?apikey=#{api_key}&host=#{domain}"

      result = "<table>"

      stats.each do |visitor|
        result << "<tr>"
        result << "<td style='width:40px'>"
        result << "<img src='/platforms/#{visitor['platform'].downcase}.png'>"
        result << "</td>"
        result << "<td style='width:40px'>"
        result << "<img src='/browsers/#{visitor['browser'].downcase}.png'>"
        result << "</td>"
        result << "<td style='width:40px'>"
        result << "<img src='/flags/#{visitor['country'].downcase}.png'>"
        result << "</td>"
        result << "<td style='width:40px'>"
        result << visitor['region'].to_s
        result << "</td>"
        result << "<td>"
        result << (visitor['title'].split('|').first || domain).strip
        result << "</td>"
        result << "</tr>"
      end

      result << "</table>"
    rescue => e
      result = "<table>"
      result << "<tr><td>Error!!</td></tr>"
      result << "<tr><td>#{stats.inspect}</td></tr>"
      result << "</table>"
    end

    def visitors
      stats = get "/live/quickstats/v3/?apikey=#{api_key}&host=#{domain}"

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

    def historical(now = Time.now)
      stats = get([
        "/historical/traffic/series/",
        "?apikey=#{api_key}&host=#{domain}",
        "&start=#{(now - 86400).to_i}",
        "&human=true&fields=new,return,people"
      ].join)["data"]

      # Chartbeat is EST and we want PST
      start  = Time.parse("#{stats["start"]} -0400").utc - (60*60*7)
      series = stats[domain]["series"]

      {
        "graph" => {
          "title" => "Visitors",
          "refreshEveryNSeconds" => 300,
          "datasequences" => [{
            "title" => "Total",
            "datapoints" => time_with_series(start, series["people"])
          },{
            "title" => "Returning",
            "datapoints" => time_with_series(start, series["return"])
          }]
        }
      }.to_json
    end

    private

    def time_with_series(time, series)
      series.map.with_index do |visitors, index|
        {
          "title" => (time + (5 * 60 * index)).strftime("%H:%M"),
          "value" => visitors.to_i
        }
      end
    end

    def get(path)
      resp, data = Net::HTTP.new(HOST).get(path)
      JSON.parse(resp.body)
    end
  end
end
