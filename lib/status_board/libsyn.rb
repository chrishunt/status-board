require 'net/http'
require 'uri'
require 'csv'
require 'json'

module StatusBoard
  class Libsyn
    attr_reader :email, :password, :show_id, :stats

    HOST = 'three.libsyn.com'

    def initialize(email, password, show_id, options = {})
      @email    = email
      @password = password
      @show_id  = show_id
      @stats    = options[:stats]
    end

    def get
      path = [ '',
        'lite/statistics/export/show_id',  show_id,
        'type/three-month/target/show/id', show_id
      ].join('/')

      resp, data = http.get(path, { 'Cookie' => cookie })

      @stats = CSV.parse(resp.body)
    end

    def totals
      episodes, downloads, months = parse(stats)

      datapoints = months.reverse.collect do |month|
        { "title" => month, "value" => downloads[month].inject(&:+) }
      end

      {
        "graph" => {
          "title" => "Downloads",
          "refreshEveryNSeconds" => 600,
          "datasequences" => [{
            "title" => "Healthy Hacker",
            "datapoints" => datapoints
          }]
        }
      }.to_json
    end

    def recent
      episodes, downloads, months = parse(stats)

      downloads = months.collect { |month| downloads[month].first }.inject(&:+)

      {
        "graph" => {
          "title" => "-",
          "refreshEveryNSeconds" => 60,
          "datasequences" => [{
            "title" => episodes.first,
            "datapoints" => [{
              "title" => months.first,
              "value" => downloads
            }]
          }]
        }
      }.to_json
    end

    def history
      path = [ '',
        'lite/statistics/export/show_id',  show_id,
        'type/daily-totals/target/show/id', show_id
      ].join('/')

      resp, data = http.get(path, { 'Cookie' => cookie })

      @stats = CSV.parse(resp.body)
      stats.shift

      datapoints = stats.map do |row|
        date = row.first.split('-')[1..-1].join('-')
        downloads = row.last

        { "title" => date, "value" => downloads }
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
      path = [ '',
        'lite/statistics/export/show_id',  show_id,
        'type/daily-totals/target/show/id', show_id
      ].join('/')

      resp, data = http.get(path, { 'Cookie' => cookie })

      @stats = CSV.parse(resp.body)
      stats.shift

      datapoint = stats.map do |row|
        date = row.first.split('-')[1..-1].join('-')
        downloads = row.last

        { "title" => date, "value" => downloads }
      end.last

      {
        "graph" => {
          "title" => "Downloads",
          "refreshEveryNSeconds" => 60,
          "datasequences" => [{
            "title" => "Today",
            "datapoints" => [ datapoint ]
          }]
        }
      }.to_json
    end

    private

    def parse(stats)
      @parse ||= begin
        downloads = Hash.new { |h, k| h[k] = [] }
        episodes  = []

        months = stats.dup.shift.slice(2..-2).map do |month|
          month.gsub("downloads__", "").capitalize
        end

        stats.each do |line|
          episode, _, *dls = *line
          next if episode.split(':').count == 1

          episodes << episode

          0.upto(months.count).each { |i| downloads[months[i]] << dls[i].to_i }
        end

        [episodes, downloads, months]
      end
    end

    def cookie
      @cookie ||= begin
        resp, data = http.post \
          '/auth/login',
          "email=#{URI.encode(email)}&password=#{URI.encode(password)}",
          { 'Content-Type'=> 'application/x-www-form-urlencoded' }

        resp.response['set-cookie']
      end
    end

    def http
      @http ||= begin
        http = Net::HTTP.new(HOST, 443)
        http.use_ssl = true
        http
      end
    end
  end
end
