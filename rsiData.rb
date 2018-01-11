require('./util.rb')
require 'openssl'
require 'yaml'
require('plotly')

class RSIData
    def initialize plotBasicData, rsiPeriod, rsiHighValue, rsiLowValue
        @plotBasicData = plotBasicData
        @exchangeRateUSDHistory = @plotBasicData.exchangeRateUSDHistory
        @RSILowArray = []
        @RSILowDateArray = []
        @RSIHighArray = []
        @RSIHighDateArray = []
        @RSIValueArray = []
        @RSIValueDateArray = []
        @RSILowerLineArray = []
        @RSIHigherLineArray = []

        @RSIPeriod = rsiPeriod
        @RSIHighValue = rsiHighValue
        @RSILowValue = rsiLowValue

        @util = Util.new()
    end

    def update index, account
        currentDate = DateTime.parse(@exchangeRateUSDHistory[index][0])

        if index > @RSIPeriod
              lastRSIPeriodLengthPrice = []
              for k in index-@RSIPeriod .. index
                lastRSIPeriodLengthPrice << @exchangeRateUSDHistory[k]['Close']
              end
              rsi = @util.getRSI(lastRSIPeriodLengthPrice)
            if rsi < @RSILowValue
                @RSILowArray.push(@exchangeRateUSDHistory[index]['Close'])
                @RSILowDateArray.push(currentDate)
            elsif rsi > @RSIHighValue
                @RSIHighArray.push(@exchangeRateUSDHistory[index]['Close'])
                @RSIHighDateArray.push(currentDate)
            end
            @RSIValueArray.push(rsi)
            @RSIValueDateArray.push(currentDate)
        end
        @RSILowerLineArray.push(@RSILowValue)
        @RSIHigherLineArray.push(@RSIHighValue)
    end

    def prepareData
        rsiLowData =
            {
            x: @RSILowDateArray,
            y: @RSILowArray,
            mode: "markers",
            type: "scatter",
            name: "RSI-"+@RSIPeriod.to_s+" below "+@RSILowValue.to_s
            }
        rsiHighData =
            {
            x: @RSIHighDateArray,
            y: @RSIHighArray,
            mode: "markers",
            type: "scatter",
            name: "RSI-"+@RSIPeriod.to_s+" above "+@RSIHighValue.to_s
            }
        rsiValueData ={
            x: @RSIValueDateArray,
            y: @RSIValueArray,
            type: "scatter",
            name: "RSI-"+@RSIPeriod.to_s+" value",
            yaxis: "y3",
            xaxis: "x"
            }
        rsiHigherLineData ={
            x: @plotBasicData.dateArray,
            y: @RSIHigherLineArray,
            type: "scatter",
            yaxis: "y3",
            xaxis: "x"
            }
        rsiLowerLineData ={
            x: @plotBasicData.dateArray,
            y: @RSILowerLineArray,
            type: "scatter",
            yaxis: "y3",
            xaxis: "x"
            }
        @plotBasicData.data << rsiLowData #[rsiLowData, rsiHighData, rsiValueData, rsiHigherLineData, rsiLowerLineData]
        @plotBasicData.data << rsiHighData
        @plotBasicData.data << rsiValueData
        @plotBasicData.data << rsiHigherLineData
        @plotBasicData.data << rsiLowerLineData

        @plotBasicData.layout[:yaxis3] = {
              title: "RSI",
              domain: [0.75, 1]
          }
      # @layout = {
      #     title: @algorithmType,
      #     yaxis: {
      #         title: "$",
      #         domain: [0, 0.65]
      #     },
      #     yaxis3: {
      #         title: "RSI",
      #         domain: [0.75, 1]
      #     },
      #     yaxis2: {
      #         title: "Ƀ",
      #         overlaying: "y",
      #         side: "right"
      #     }
      #}
    end
end
