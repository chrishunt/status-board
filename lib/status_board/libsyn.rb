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
      stats = get [ '',
        'lite/statistics/export/show_id',  show_id,
        'type/three-month/target/show/id', show_id
      ].join('/')

      episodes, downloads, months = parse(stats)

      datapoints = months.reverse.collect do |month|
        { "title" => month, "value" => downloads[month].inject(&:+) }
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
      stats = get [ '',
        'lite/statistics/export/show_id',  show_id,
        'type/three-month/target/show/id', show_id
      ].join('/')

      episodes, downloads, months = parse(stats)

      downloads = months.collect { |month| downloads[month].first }.inject(&:+)

      {
        "graph" => {
          "title" => "-",
          "refreshEveryNSeconds" => 120,
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
      stats = get [ '',
        'lite/statistics/export/show_id',  show_id,
        'type/daily-totals/target/show/id', show_id
      ].join('/')

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
      stats = get [ '',
        'lite/statistics/export/show_id',  show_id,
        'type/daily-totals/target/show/id', show_id
      ].join('/')

      stats.shift

      datapoint = stats.map do |row|
        date = row.first.split('-')[1..-1].join('-')
        downloads = row.last

        { "title" => date, "value" => downloads }
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

    def parse(stats)
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
