require 'test_helper'
require 'status_board/chartbeat'


# http://api.chartbeat.com/live/recent/v3/?apikey=e468266d6fa85b4c32f6de0982ef8c00&host=healthyhacker.com

module StatusBoard
  describe Chartbeat do
    describe '#summary' do
      it 'returns a table summary of current visitors' do
        VCR.use_cassette('chartbeat/summary') do
          chartbeat = Chartbeat.new "123", "example.com"

          assert_equal "<table><tr><td style='width:40px'>GB</td><td>Example Site Podcast</td></tr><tr><td style='width:40px'>CA</td><td>1: Why I use Vim</td></tr><tr><td style='width:40px'>US</td><td>1: Why I use Vim</td></tr></table>",
          chartbeat.summary
        end
      end
    end
  end
end
