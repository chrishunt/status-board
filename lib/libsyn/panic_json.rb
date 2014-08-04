require 'json'

module Libsyn
  class PanicJson
    attr_reader :input

    def initialize(input)
      @input = input
    end

    def to_s
      downloads = Hash.new { |h, k| h[k] = [] }
      episodes  = []

      months = input.shift.slice(2..-2).map do |month|
        month.gsub("downloads__", "").capitalize
      end

      input.each do |line|
        episode, _, *dls = *line
        next if episode.split(':').count == 1

        episodes << episode

        0.upto(months.count).each { |i| downloads[months[i]] << dls[i].to_i }
      end

      last_stats = []
      total_stats = []

      months.reverse.each do |month|
        last_stats << { "title" => month, "value" => downloads[month].first }
        total_stats << { "title" => month, "value" => downloads[month].inject(&:+) }
      end

      last_episode = {
        "title" => episodes.first,
        "datapoints" => last_stats
      }

      total_episodes = {
        "title" => "Total",
        "datapoints" => total_stats
      }

      {
        "graph" => {
          "title" => "Downloads",
          "refreshEveryNSeconds" => 120,
          "datasequences" => [ last_episode, total_episodes ]
        }
      }.to_json
    end
  end
end
