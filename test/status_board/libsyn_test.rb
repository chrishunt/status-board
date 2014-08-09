require 'test_helper'
require 'status_board/libsyn'

module StatusBoard
  describe Libsyn do
    describe '#totals' do
      it 'returns json for monthly download totals' do
        VCR.use_cassette('libsyn/three-month') do
          libsyn = Libsyn.new('me@example.com', 'secret', '1234')

          assert_equal ({
            "graph" => {
              "title" => "Monthly",
              "total" => true,
              "refreshEveryNSeconds" => 600,
              "datasequences" => [{
                "title" => "Downloads",
                "color" => "yellow",
                "datapoints" => [
                  {"title" => "June",   "value" => 0},
                  {"title" => "July",   "value" => 181},
                  {"title" => "August", "value" => 438}
                ]
              }]
            }
          }), JSON.parse(libsyn.totals)
        end
      end
    end

    describe '#recent' do
      it 'returns json for the most recent episode' do
        VCR.use_cassette('libsyn/three-month') do
          libsyn = Libsyn.new('me@example.com', 'secret', '1234')

          assert_equal ({
            "graph" => {
              "title" => "-",
              "refreshEveryNSeconds" => 120,
              "datasequences" => [{
                "title" => "1: Why I use Vim",
                "datapoints" => [
                  { "title" => "August", "value" => 619 }
                ]
              }]
            }
          }), JSON.parse(libsyn.recent)
        end
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
                "color" => "orange",
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
