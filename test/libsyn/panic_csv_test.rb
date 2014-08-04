require 'test_helper'
require 'libsyn/panic_csv'

module Libsyn
  describe PanicCsv do
    describe '#to_s' do
      it 'returns a string in the correct format for Panic Status Board' do
        csv = PanicCsv.new([[
          "item_title",
          "release_date",
          "downloads__august",
          "downloads__july",
          "downloads__june",
          "downloads__total"
        ],[
          "2: This is a test", "2014-08-01 00:52:24",
          "500", "0", "1", "619"
        ],[
          "1: Why I use Vim", "2014-07-30 00:52:24",
          "438", "181", "0", "619"
        ],[
          "2", "2014-07-25 04:33:45",
          "0", "2", "0", "2"
        ]])

        assert_equal [
          "Podcast Downloads,2: This is a test,1: Why I use Vim",
          "June,1,0",
          "July,0,181",
          "August,500,438",
          "Totals", ""
        ].join("\n"), csv.to_s
      end
    end
  end
end
