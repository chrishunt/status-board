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
        ]])

        assert_equal [
          "Downloads,3: Most recent,2: This is a test,1: Why I use Vim",
          "June,12,9,6",
          "July,11,8,5",
          "August,10,7,4",
          "Totals", ""
        ].join("\n"), csv.to_s
      end
    end
  end
end
