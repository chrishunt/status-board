require 'json'

module Libsyn
  class PanicJson
    attr_reader :input

    def initialize(input)
      @input = input
    end

    def totals
      episodes, downloads, months = parse(input)

      datapoints = months.reverse.collect do |month|
        { "title" => month, "value" => downloads[month].inject(&:+) }
      end

      {
        "graph" => {
          "title" => "Downloads",
          "refreshEveryNSeconds" => 120,
          "datasequences" => [{
            "title" => "Total",
            "datapoints" => datapoints
          }]
        }
      }.to_json
    end

    def most_recent
      episodes, downloads, months = parse(input)

      {
        "graph" => {
          "title" => episodes.first,
          "refreshEveryNSeconds" => 120,
          "datasequences" => [{
            "title" => "Downloads",
            "datapoints" => [{
              "title" => months.first,
              "value" => downloads[months.first].first
            }]
          }]
        }
      }.to_json
    end

    def to_s
      [most_recent, totals].join "\n\n"
    end

    private

    def parse(input)
      @parse ||= begin
        downloads = Hash.new { |h, k| h[k] = [] }
        episodes  = []

        months = input.dup.shift.slice(2..-2).map do |month|
          month.gsub("downloads__", "").capitalize
        end

        input.each do |line|
          episode, _, *dls = *line
          next if episode.split(':').count == 1

          episodes << episode

          0.upto(months.count).each { |i| downloads[months[i]] << dls[i].to_i }
        end

        [episodes, downloads, months]
      end
    end
  end
end
