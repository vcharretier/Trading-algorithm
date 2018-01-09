require('./data_currency.rb')
#require('./random_algo.rb')
require('./simple_algo.rb')
#require('./static_algo.rb')
require('./account.rb')
require('./plotData.rb')
#require('./RSIData.rb')

def RunAlgo algo, account, exchangeRateUSDHistory
    plotData = PlotData.new(exchangeRateUSDHistory, algo.name)
    #rsiData = RSIData.new(plotData, RSI_PERIOD, RSI_HIGH_VALUE, RSI_LOW_VALUE)

    for i in 0..exchangeRateUSDHistory.length-1
        algo.update(exchangeRateUSDHistory[i]['Close'])
        plotData.update(i, account)
        #rsiData.update(i, account)
    end
    plotData.prepareData()
    #rsiData.prepareData()
    plotData.plotData()
end

data = DataCurrency.new('csv/BTC_hour.csv')

filename = "C:/Temp/result.csv"
balanceUSD = 0

RSI_LOW_VALUE = 30
RSI_HIGH_VALUE = 70
RSI_PERIOD = 14

for k in 0..0
    account = Account.new(10000)
    exchangeRateUSDHistory = data.history
    RunAlgo(SimpleAlgo.new(account, RSI_PERIOD, RSI_LOW_VALUE, RSI_HIGH_VALUE), account, exchangeRateUSDHistory)
    balanceUSD = account.balanceUSD(exchangeRateUSDHistory[exchangeRateUSDHistory.length-1]['Close'])
    puts RSI_PERIOD.to_s + "," + RSI_LOW_VALUE.to_s + "," + RSI_HIGH_VALUE.to_s + "," + balanceUSD.to_s
end
