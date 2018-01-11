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
        @data = [balanceUSDData,fundsUSDData,fundsCryptoData,cryptoValueData]
        @layout = {
            title: @algorithmType,
            yaxis: {
                title: "$",
                domain: [0, 0.65]
            },
            yaxis2: {
                title: "Ƀ",
                overlaying: "y",
                side: "right"
            }
        }
    end

    def exchangeRateUSDHistory
      @exchangeRateUSDHistory
    end

    def data
      @data
    end

    def dateArray
      @dateArray
    end

    def layout
      @layout
    end


    def plotData
        graphOptions = {layout: @layout, filename: "date-axes", fileopt: "overwrite"}
        @plotly.plot(@data, graphOptions) do |err, msg|
            puts msg
            puts err
        end
    end
end
