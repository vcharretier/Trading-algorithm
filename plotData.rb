require('./util.rb')
require 'openssl'
require('plotly')

RSILowValue = 30
RSIHighValue = 70
RSIPeriod = 14

class PlotData
    def initialize exchangeRateUSDHistory, algorithmType
        plotly = PlotLy.new('vcharretier', 'KRGpk3y9XhZRmVuMfYAy')
        @exchangeRateUSDHistory = exchangeRateUSDHistory
        @algorithmType = algorithmType

        @dateArray = []
        @balanceUSDArray = []
        @fundsUSDArray = []
        @fundsCryptoArray = []
        @cryptoValueArray = []

        @RSILowArray = []
        @RSILowDateArray = []
        @RSIHighArray = []
        @RSIHighDateArray = []
        @RSIValueArray = []
        @RSIValueDateArray = []
        @RSILowerLineArray = []
        @RSIHigherLineArray = []

        @util = Util.new()

        @data = []
    end

    def update index, account
        currentDate = Date.parse(@exchangeRateUSDHistory[index][0])
        @dateArray << currentDate
        @balanceUSDArray.push(account.balanceUSD(@exchangeRateUSDHistory[index][4]))
        @fundsUSDArray.push(account.fundsUSD)
        @fundsCryptoArray.push(account.fundsCrypto)
        @cryptoValueArray.push(@exchangeRateUSDHistory[index][4])

        if index > RSIPeriod
              puts @exchangeRateUSDHistory
              rsi = 50#@util.getRSI(@exchangeRateUSDHistory.slice(index-RSIPeriod, index).map(a => a[4]), index)
            if rsi < RSILowValue
                @RSILowArray.push(@exchangeRateUSDHistory[index][4])
                @RSILowDateArray.push(currentDate)
            elsif rsi > RSIHighValue
                @RSIHighArray.push(@exchangeRateUSDHistory[index][4])
                @RSIHighDateArray.push(currentDate)
            end
            @RSIValueArray.push(rsi)
            @RSIValueDateArray.push(currentDate)
        end
        @RSILowerLineArray.push(RSILowValue)
        @RSIHigherLineArray.push(RSIHighValue)
    end

    def prepareData
        balanceUSDData =
        {
            x: @dateArray,
            y: @balanceUSDArray,
            type: "scatter",
            name: "Balance in $"
        }
        fundsUSDData =
            {
            x: @dateArray,
            y: @fundsUSDArray,
            type: "scatter",
            name: "Funds in $"
            }
        fundsCryptoData =
            {
            x: @dateArray,
            y: @fundsCryptoArray,
            type: "scatter",
            name: "Funds in Ƀ",
            yaxis: "y2"
            }
        cryptoValueData =
            {
            x: @dateArray,
            y: @cryptoValueArray,
            type: "scatter",
            name: "Ƀ value in $"
            }
        # RSILowData =
        #     {
        #     x: @RSILowDateArray,
        #     y: @RSILowArray,
        #     mode: "markers",
        #     type: "scatter",
        #     name: "RSI-"+@RSIPeriod+" below "+@RSILowValue
        #     }
        # RSIHighData =
        #     {
        #     x: @RSIHighDateArray,
        #     y: @RSIHighArray,
        #     mode: "markers",
        #     type: "scatter",
        #     name: "RSI-"+@RSIPeriod+" above "+@RSIHighValue
        #     }
        # RSIValueData ={
        #     x: @RSIValueDateArray,
        #     y: @RSIValueArray,
        #     type: "scatter",
        #     name: "RSI-"+@RSIPeriod+" value",
        #     yaxis: "y3",
        #     xaxis: "x"
        #     }
        # RSIHigherLineData ={
        #     x: @dateArray,
        #     y: @RSIHigherLineArray,
        #     type: "scatter",
        #     yaxis: "y3",
        #     xaxis: "x"
        #     }
        # RSILowerLineData ={
        #     x: @dateArray,
        #     y: @RSILowerLineArray,
        #     type: "scatter",
        #     yaxis: "y3",
        #     xaxis: "x"
        #     }
        @data = [balanceUSDData,fundsUSDData,fundsCryptoData,cryptoValueData]#, RSILowData, RSIHighData, RSIValueData, RSIHigherLineData, RSILowerLineData]
        @layout = {
            title: @algorithmType,
            yaxis: {
                title: "$",
                domain: [0, 0.65]
            },
            yaxis3: {
                title: "RSI",
                domain: [0.75, 1]
            },
            yaxis2: {
                title: "Ƀ",
                overlaying: "y",
                side: "right"
            }
        }
    end

    def addData newData
        @data.push(newData)
    end

    def plotData
        graphOptions = {layout: @layout, filename: "date-axes", fileopt: "overwrite"}
        plotly.plot(@data, graphOptions) do |err, msg|
            puts msg
            puts err
        end
    end
end
