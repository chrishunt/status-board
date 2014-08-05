require 'test_helper'
require 'status_board/libsyn'

module StatusBoard
  describe Libsyn do
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

    describe '#get' do
      it 'gets a CSV' do
        VCR.use_cassette('get') do
          assert_equal [[
            "item_title",
            "release_date",
            "downloads__august",
            "downloads__july",
            "downloads__june",
            "downloads__total"
          ],[
            "1: Why I use Vim", "2014-07-30 00:52:24",
            "438", "181", "0", "619"
          ],[
            "1", "2014-07-26 04:01:07",
            "0", "18", "0", "18"
          ],[
            "2", "2014-07-25 04:33:45",
            "0", "2", "0", "2"
          ]], Libsyn.new('me@example.com', 'secret', '1234').get
        end
      end
    end

    describe '#totals' do
      it 'returns json for monthly download totals' do
        libsyn = Libsyn.new('', '', '', :stats => libsyn_stats)

        assert_equal ({
          "graph" => {
            "title" => "Downloads",
            "refreshEveryNSeconds" => 120,
            "datasequences" => [{
              "title" => "Total",
              "datapoints" => [
                { "title" => "June",   "value" => 27 },
                { "title" => "July",   "value" => 24 },
                { "title" => "August", "value" => 21 }
              ]
            }]
          }
        }), JSON.parse(libsyn.totals)
      end
    end

    describe '#most_recent' do
      it 'returns json for the most recent episode' do
        libsyn = Libsyn.new('', '', '', :stats => libsyn_stats)

        assert_equal ({
          "graph" => {
            "title" => "Downloads",
            "refreshEveryNSeconds" => 120,
            "datasequences" => [{
              "title" => "3: Most recent",
              "datapoints" => [
                { "title" => "August", "value" => 33 }
              ]
            }]
          }
        }), JSON.parse(libsyn.most_recent)
      end
    end
  end
end
