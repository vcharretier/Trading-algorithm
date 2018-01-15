require('./util.rb')
# Algorithm based on Relative Strength Index
# Buy crypto when RSI was under 30 and back above 30
# Sell crypto when RSI was over 70 and back below 70
class SimpleAlgo
  def initialize(account, rsi_period, rsi_low_value, rsi_high_value)
    @util = Util.new
    @account = account
    @name = 'Simple'
    @rsi_period = rsi_period
    @last_prices = []
    @rsi_low_value = rsi_low_value
    @rsi_high_value = rsi_high_value
    @is_higher_than_rsi_high_value = false
    @is_lower_than_rsi_high_value = false
  end

  def update(current_exchange_rate_usd)
    @last_prices.push(current_exchange_rate_usd)
    # if there is enough data to compute RSI
    return unless @last_prices.length > @rsi_period
    # remove first element to keep last_prices-array
    # the same length than RSI period
    @last_prices.shift
    rsi = @util.get_rsi(@last_prices)
    case rsi
    when rsi < @rsi_low_value
      @is_lower_than_rsi_high_value = true
    when rsi > @rsi_high_value
      @is_higher_than_rsi_high_value = true
    when rsi >= @rsi_low_value
      inf_low_value(current_exchange_rate_usd)
    # if RSI was over RSIHighValue but not anymore,
    # then price is decreasing, so it's times to sell
    when rsi <= @rsi_high_value
      inf_high_value(current_exchange_rate_usd)
    end
  end

  def inf_low_value(current_exchange_rate_usd)
    # if RSI was under RSILowValue but not anymore,
    # then price is raising, so it's times to buy
    if @is_lower_than_rsi_high_value
      @account.buy(@account.fundsUSD / 2, current_exchange_rate_usd)
    end
    @is_lower_than_rsi_high_value = false # reset value
  end

  def inf_high_value(current_exchange_rate_usd)
    if @is_higher_than_rsi_high_value
      @account.sell(
        @account.fundsCrypto * current_exchange_rate_usd / 2,
        current_exchange_rate_usd
      )
    end
    @is_higher_than_rsi_high_value = false
  end
  attr_reader :name
end
