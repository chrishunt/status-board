require 'csv'

module Libsyn
  class PanicCsv
    attr_reader :input

    def initialize(input)
      @input = input
    end

    def to_s
      CSV.generate do |csv|
        downloads = Hash.new { |h, k| h[k] = [] }
        episodes  = []

        months = input.shift.slice(2..-2).map do |month|
          month.gsub("downloads__", "").capitalize
        end

        input.each do |line|
          episode, _, *dls = *line
          next if episode.split(':').count == 1

          episodes << episode

          0.upto(months.count).each { |i| downloads[months[i]] << dls[i] }
        end

        csv << ["Downloads", *episodes]
        months.each { |month| csv << [month, *downloads[month]] }
      end
    end
  end
end
