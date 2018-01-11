require_relative('../util.rb')
require_relative('../data_currency.rb')
require "test/unit"

class TestRSI < Test::Unit::TestCase

  def testRSI
    data = DataCurrency.new('unit_test/test_RSI.csv')
    exchangeRateUSDHistory = data.history
    rsiPERIOD = 14
    util = Util.new()

    for index in 0 ... exchangeRateUSDHistory.length
      if index >= rsiPERIOD
        lastRSIPeriodLengthPrice = []
        for k in index-rsiPERIOD ... index
          lastRSIPeriodLengthPrice << exchangeRateUSDHistory[k]['Close']
        end
        ourRsi = util.getRSI(lastRSIPeriodLengthPrice).to_i
        realRsi = exchangeRateUSDHistory[index]['14-dayRSI'].to_i
        assert_equal(realRsi, ourRsi,"k is #{index}")
      end
    end
  end
end