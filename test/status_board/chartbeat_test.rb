require 'test_helper'
require 'status_board/chartbeat'

module StatusBoard
  describe Chartbeat do
    describe '#summary' do
      it 'returns a table summary of current visitors as html' do
        VCR.use_cassette('chartbeat/summary') do
          chartbeat = Chartbeat.new "123", "example.com"

          assert_equal "<table><tr><td style='width:40px'><img src='/platforms/desktop.png'></td><td style='width:40px'><img src='/browsers/chrome.png'></td><td style='width:40px'><img src='/flags/gb.png'></td><td style='width:40px'>A1</td><td>Example Site Podcast</td></tr><tr><td style='width:40px'><img src='/platforms/desktop.png'></td><td style='width:40px'><img src='/browsers/chrome.png'></td><td style='width:40px'><img src='/flags/ca.png'></td><td style='width:40px'>AB</td><td>1: Why I use Vim</td></tr><tr><td style='width:40px'><img src='/platforms/desktop.png'></td><td style='width:40px'><img src='/browsers/firefox.png'></td><td style='width:40px'><img src='/flags/us.png'></td><td style='width:40px'>VA</td><td>1: Why I use Vim</td></tr></table>",
          chartbeat.summary
        end
      end
    end

    describe '#visitors' do
      it 'returns the number of visitors as json' do
        VCR.use_cassette('chartbeat/visitors') do
          chartbeat = Chartbeat.new "123", "example.com"

          assert_equal ({
            "graph" => {
              "title" => "Visitors",
              "refreshEveryNSeconds" => 10,
              "datasequences" => [{
                "title" => "healthyhacker.com",
                "datapoints" => [
                  { "title" => "visitors", "value" => 2 }
                ]
              }]
            }
          }), JSON.parse(chartbeat.visitors)
        end
      end
    end

    describe '#historical' do
      it 'returns the historical number of visitors as json' do
        VCR.use_cassette('chartbeat/historical') do
          chartbeat = Chartbeat.new "123", "example.com"

          now = Time.parse("2014-08-06 12:10:32 -0700")
          result = JSON.parse(chartbeat.historical(now))["graph"]

          assert_equal "Visitors", result["title"]
          assert_equal 300, result["refreshEveryNSeconds"]

          assert_equal ["Total", "Returning"],
          result["datasequences"].map { |s| s["title"] }
        end
      end
    end
  end
end
