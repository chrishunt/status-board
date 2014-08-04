require 'test_helper'
require 'libsyn/panic_json'

module Libsyn
  describe PanicJson do
    def libsyn_stats
      [[
        "item_title",
        "release_date",
        "downloads__august",
        "downloads__july",
        "downloads__june",
        "downloads__total"
      ],[
        "3: Most recent", "2014-08-02 00:52:24",
        "10", "11", "12", "33"
      ],[
        "2: This is a test", "2014-08-01 00:52:24",
        "7", "8", "9", "24"
      ],[
        "1: Why I use Vim", "2014-07-30 00:52:24",
        "4", "5", "6", "15"
      ],[
        "2", "2014-07-25 04:33:45",
        "1", "2", "3", "6"
      ]]
    end

    describe '#totals' do
      it 'returns json for monthly download totals' do
        json = PanicJson.new(libsyn_stats)

        assert_equal ({
          "graph" => {
            "title" => "Downloads",
            "refreshEveryNSeconds" => 120,
            "datasequences" => [{
              "title" => "",
              "datapoints" => [
                { "title" => "June",   "value" => 27 },
                { "title" => "July",   "value" => 24 },
                { "title" => "August", "value" => 21 }
              ]
            }]
          }
        }), JSON.parse(json.totals)
      end
    end

    describe '#most_recent' do
      it 'returns json for the most recent episode' do
        json = PanicJson.new(libsyn_stats)

        assert_equal ({
          "graph" => {
            "title" => "3: Most recent",
            "refreshEveryNSeconds" => 120,
            "datasequences" => [{
              "title" => "",
              "datapoints" => [
                { "title" => "August", "value" => 10 }
              ]
            }]
          }
        }), JSON.parse(json.most_recent)
      end
    end
  end
end
