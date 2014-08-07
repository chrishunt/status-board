require 'test_helper'
require 'status_board/libsyn'

module StatusBoard
  describe Libsyn do
    describe '#get' do
      it 'gets a CSV' do
        VCR.use_cassette('libsyn/get') do
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
        libsyn = Libsyn.new('', '', '', :stats => libsyn_stats)

        assert_equal ({
          "graph" => {
            "title" => "Downloads",
            "refreshEveryNSeconds" => 600,
            "datasequences" => [{
              "title" => "Healthy Hacker",
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

    describe '#recent' do
      it 'returns json for the most recent episode' do
        libsyn = Libsyn.new('', '', '', :stats => libsyn_stats)

        assert_equal ({
          "graph" => {
            "title" => "-",
            "refreshEveryNSeconds" => 120,
            "datasequences" => [{
              "title" => "3: Most recent",
              "datapoints" => [
                { "title" => "August", "value" => 33 }
              ]
            }]
          }
        }), JSON.parse(libsyn.recent)
      end
    end

    describe '#today' do
      it 'returns json for total downloads today' do
        VCR.use_cassette('libsyn/today') do
          libsyn = Libsyn.new('me@example.com', 'secret', '1234')

          assert_equal ({
            "graph" => {
              "title" => "Today",
              "refreshEveryNSeconds" => 60,
              "datasequences" => [{
                "title" => "Total Downloads",
                "datapoints" => [
                  { "title" => "08-07", "value" => "52" }
                ]
              }]
            }
          }), JSON.parse(libsyn.today)
        end
      end
    end

    describe '#history' do
      it 'returns json for the daily history of downloads' do
        VCR.use_cassette('libsyn/history') do
          libsyn = Libsyn.new('me@example.com', 'secret', '1234')

          assert_equal ({
            "graph"=> {
              "title"=>"Daily",
              "refreshEveryNSeconds"=>600,
              "datasequences"=> [{
                "title"=>"Downloads",
                "datapoints"=>[
                  { "title" => "07-25", "value" => "4" },
                  { "title" => "07-26", "value" => "16" },
                  { "title" => "07-27", "value" => "0" },
                  { "title" => "07-28", "value" => "0" },
                  { "title" => "07-29", "value" => "0" },
                  { "title" => "07-30", "value" => "57" },
                  { "title" => "07-31", "value" => "124" },
                  { "title" => "08-01", "value" => "337" },
                  { "title" => "08-02", "value" => "76" },
                  { "title" => "08-03", "value" => "27" },
                  { "title" => "08-04", "value" => "24" },
                  { "title" => "08-05", "value" => "479" },
                  { "title" => "08-06", "value" => "75" }
                ]
              }]
            }
          }), JSON.parse(libsyn.history)
        end
      end
    end
  end
end
