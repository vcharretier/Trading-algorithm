# Algorithm based on Relative Strength Index
# Buy crypto when RSI was under 30 and back above 30
# Sell crypto when RSI was over 70 and back below 70

require('./util.rb')


class SimpleAlgo

    def initialize account, rsi_period, rsi_low_value, rsi_high_value
        @util = Util.new
        @account = account
        @name = "Simple"
        @rsi_period = rsi_period
        @lastPrices = []
        @rsi_low_value = rsi_low_value
        @rsi_high_value = rsi_high_value
        @IsHigherThanRSIHighValue = false
        @IsLowerThanRSILowValue = false
    end

    def update currentExchangeRateUSD
        @lastPrices.push(currentExchangeRateUSD)
        if @lastPrices.length > @rsi_period # if there is enough data to compute RSI
            @lastPrices.shift() # remove first element to keep lastPrices-array the same length than RSI period
            rsi = @util.getRSI(@lastPrices)
            if rsi < @rsi_low_value
                @IsLowerThanRSILowValue = true
            elsif rsi > @rsi_high_value
                @IsHigherThanRSIHighValue = true
            else
                if rsi >= @rsi_low_value
                    if @IsLowerThanRSILowValue # if RSI was under RSILowValue but not anymore, then price is raising, so it's times to buy
                        @account.buy(@account.fundsUSD/2, currentExchangeRateUSD)
                    end
                    @IsLowerThanRSILowValue = false # reset value
                end
                if rsi <= @rsi_high_value # if RSI was over RSIHighValue but not anymore, then price is decreasing, so it's times to sell
                    if @IsHigherThanRSIHighValue
                        @account.sell(@account.fundsCrypto*currentExchangeRateUSD/2, currentExchangeRateUSD)
                    end
                    @IsHigherThanRSIHighValue = false
                end
            end
        end
    end

    def name
      @name
    end
end
