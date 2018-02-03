require_relative('../util.rb')
require_relative('../data_currency.rb')
require 'test/unit'

# Test de l'algorithme RSI
class TestRSI < Test::Unit::TestCase
  def test_rsi
    data = DataCurrency.new('test_RSI.csv')
    exchange_rate_usd_histo = data.history
    rsi_period = 14
    util = Util.new
    launch_rsi(exchange_rate_usd_histo, rsi_period, util)
  end

  def launch_rsi(exchange_rate_usd_histo, rsi_period, util)
    Array(0...exchange_rate_usd_histo.length).each do |index|
      next unless index >= rsi_period
      last_rsi_period_length_price = []
      Array(index - rsi_period...index + 1).each do |idx|
        last_rsi_period_length_price << exchange_rate_usd_histo[idx]['Close']
      end
      assert_equal(
        util.get_rsi(last_rsi_period_length_price),
        exchange_rate_usd_histo[index]['14-dayRSI'].to_f,
        "index is #{index}"
      )
    end
  end
end
