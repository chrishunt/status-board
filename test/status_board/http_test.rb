require 'test_helper'
require 'status_board/http'

module StatusBoard
  describe Http do
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
          ]], Http.new('me@example.com', 'secret', '1234').get
        end
      end
    end
  end
end
