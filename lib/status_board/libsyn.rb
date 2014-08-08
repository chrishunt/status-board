require 'net/http'
require 'uri'
require 'csv'
require 'json'

module StatusBoard
  class Libsyn
    attr_reader :email, :password, :show_id

    HOST = 'three.libsyn.com'

    def initialize(email, password, show_id)
      @email    = email
      @password = password
      @show_id  = show_id
    end

    def totals
      datapoints = monthly_stats[:months].reverse.collect do |month|
        {
          "title" => month,
          "value" => monthly_stats[:downloads][month].inject(&:+)
        }
      end

      {
        "graph" => {
          "title" => "Monthly",
          "refreshEveryNSeconds" => 600,
          "datasequences" => [{
            "title" => "Downloads",
            "datapoints" => datapoints
          }]
        }
      }.to_json
    end

    def recent
      recent_downloads = monthly_stats[:months].collect do |month|
        monthly_stats[:downloads][month].first
      end.inject(&:+)

      {
        "graph" => {
          "title" => "-",
          "refreshEveryNSeconds" => 120,
          "datasequences" => [{
            "title" => monthly_stats[:episodes].first,
            "datapoints" => [{
              "title" => monthly_stats[:months].first,
              "value" => recent_downloads
            }]
          }]
        }
      }.to_json
    end

    def history
      datapoints = daily_stats[:dates].map do |date|
        { "title" => date, "value" => daily_stats[:downloads][date] }
      end

      {
        "graph" => {
          "title" => "Daily",
          "refreshEveryNSeconds" => 600,
          "datasequences" => [{
            "title" => "Downloads",
            "datapoints" => datapoints
          }]
        }
      }.to_json
    end

    def today
      datapoint = daily_stats[:dates].map do |date|
        { "title" => date, "value" => daily_stats[:downloads][date] }
      end.last

      {
        "graph" => {
          "title" => "Today",
          "refreshEveryNSeconds" => 60,
          "datasequences" => [{
            "title" => "Total Downloads",
            "datapoints" => [ datapoint ]
          }]
        }
      }.to_json
    end

    private

    def daily_stats
      @daily_stats ||= begin
        result = {
          :dates => [],
          :downloads => Hash.new { |h, k| h[k] = [] }
        }

        stats = get [ '',
          'lite/statistics/export/show_id',  show_id,
          'type/daily-totals/target/show/id', show_id
        ].join('/')

        stats.shift

        datapoints = stats.map do |row|
          date = row.first.split('-')[1..-1].join('-')

          result[:dates] << date
          result[:downloads][date] = row.last
        end

        result
      end
    end

    def monthly_stats
      @monthly_stats ||= begin
        result = {
          :episodes  => [],
          :months    => [],
          :downloads => Hash.new { |h, k| h[k] = [] }
        }

        stats = get [ '',
          'lite/statistics/export/show_id',  show_id,
          'type/three-month/target/show/id', show_id
        ].join('/')

        result[:months] = stats.shift.slice(2..-2).map do |month|
          month.gsub("downloads__", "").capitalize
        end

        stats.each do |line|
          episode, _, *dls = *line
          next if episode.split(':').count == 1

          result[:episodes] << episode

          0.upto(result[:months].count).each do |i|
            result[:downloads][result[:months][i]] << dls[i].to_i
          end
        end

        result
      end
    end

    def get(path)
      http = Net::HTTP.new(HOST, 443)
      http.use_ssl = true

      response, data = http.post \
        '/auth/login',
        "email=#{URI.encode(email)}&password=#{URI.encode(password)}",
        { 'Content-Type'=> 'application/x-www-form-urlencoded' }

      cookie = response.response['set-cookie']

      response, data = http.get(path, { 'Cookie' => cookie })

      CSV.parse(response.body)
    end
  end
end
