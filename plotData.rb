require('./util.rb')
require 'openssl'
require 'yaml'
require('plotly')

RSILowValue = 30
RSIHighValue = 70
RSIPeriod = 14

class PlotData
    def initialize exchangeRateUSDHistory, algorithmType
        config = YAML.load_file('./config_plotly.yml')

        @plotly = PlotLy.new(config['plotly']['username'], config['plotly']['private_key'])
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
        currentDate = DateTime.parse(@exchangeRateUSDHistory[index][0])
        @dateArray << currentDate
        @balanceUSDArray.push(account.balanceUSD(@exchangeRateUSDHistory[index]['Close']))
        @fundsUSDArray.push(account.fundsUSD)
        @fundsCryptoArray.push(account.fundsCrypto)
        @cryptoValueArray.push(@exchangeRateUSDHistory[index]['Close'])

        if index > RSIPeriod
              rsi = 50#@util.getRSI(@exchangeRateUSDHistory.slice(index-RSIPeriod, index).map(a => a['Close']), index)
              lastRSIPeriodLengthPrice = []
              for k in index-RSIPeriod .. index
                lastRSIPeriodLengthPrice << @exchangeRateUSDHistory[k]['Close']
              end
              rsi = @util.getRSI(lastRSIPeriodLengthPrice)
            if rsi < RSILowValue
                @RSILowArray.push(@exchangeRateUSDHistory[index]['Close'])
                @RSILowDateArray.push(currentDate)
            elsif rsi > RSIHighValue
                @RSIHighArray.push(@exchangeRateUSDHistory[index]['Close'])
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
            #type: "scatter",
            name: "Ƀ value in $"
            }
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
            x: @dateArray,
            y: @RSIHigherLineArray,
            type: "scatter",
            yaxis: "y3",
            xaxis: "x"
            }
        rsiLowerLineData ={
            x: @dateArray,
            y: @RSILowerLineArray,
            type: "scatter",
            yaxis: "y3",
            xaxis: "x"
            }
        @data = [balanceUSDData,fundsUSDData,fundsCryptoData,cryptoValueData, rsiLowData, rsiHighData, rsiValueData, rsiHigherLineData, rsiLowerLineData]
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
        @plotly.plot(@data, graphOptions) do |err, msg|
            puts msg
            puts err
        end
    end
end
