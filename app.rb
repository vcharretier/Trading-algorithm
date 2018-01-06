require('data.rb')
require('random_algo.rb')
require('simple_algo.rb')
require('static_algo.rb')
require('util.rb')
require('account.rb')

plotly = Plotly.new('Tiboh', 'bpXscfMKbSEhYRVbx0iS')

AlgoType = {
    STATIC: 'static',
    RANDOM: 'random',
    SIMPLE: 'simple'
}

def RunAlgo algorithmType, csvFile, startDate, endDate
    data = Data.new(csvFile)
    account = Account.new(10000)

    case algorithmType
    when AlgoType.STATIC
      algo = StaticAlgo.new(account)
    when AlgoType.RANDOM
      algo = RandomAlgo.new(account)
    when AlgoType.SIMPLE
      algo = SimpleAlgo.new(account)
    else
      raise ("This algorithm type is not recognized '" + algorithmType + "'")

    dateArray = []
    balanceUSDArray = []
    fundsUSDArray = []
    fundsCryptoArray = []
    cryptoValueArray = []

    #//var exchangeRateUSDHistory = data.getBuyPrice(startDate, endDate);
    exchangeRateUSDHistory = data.history
    for(i = 0 ; i < exchangeRateUSDHistory.length ; i++)
        algo.update(exchangeRateUSDHistory[i].Close)
        dateArray.push(exchangeRateUSDHistory[i].Date)
        balanceUSDArray.push(account.balanceUSD(exchangeRateUSDHistory[i].Close))
        fundsUSDArray.push(account.fundsUSD)
        fundsCryptoArray.push(account.fundsCrypto)
        cryptoValueArray.push(exchangeRateUSDHistory[i].Close)

    puts (account.balanceUSD(exchangeRateUSDHistory[exchangeRateUSDHistory.length-1].Close))

    PlotData(algorithmType, dateArray, balanceUSDArray, fundsUSDArray, fundsCryptoArray, cryptoValueArray)

def PlotData algorithmType, dateArray, balanceUSDArray, fundsUSDArray, fundsCryptoArray, cryptoValueArray
    balanceUSDData =
    {
        x: dateArray,
        y: balanceUSDArray,
        type: "scatter",
        name: "Balance in $"
    }
    fundsUSDData =
    {
      x: dateArray,
      y: fundsUSDArray,
      type: "scatter",
      name: "Funds in $"
    }
    fundsCryptoData =
        {
        x: dateArray,
        y: fundsCryptoArray,
        type: "scatter",
        name: "Funds in Ƀ",
        yaxis: "y2"
        }
    var cryptoValueData =
        {
        x: dateArray,
        y: cryptoValueArray,
        type: "scatter",
        name: "Ƀ value in $"
        }
    data = [balanceUSDData,fundsUSDData,fundsCryptoData,cryptoValueData]

    layout = {
        title: algorithmType,
        yaxis: {
            title: "$"
        },
        yaxis2: {
        title: "Ƀ",
        overlaying: "y",
        side: "right"
        }
    };
    graphOptions = {layout: layout, filename: "date-axes", fileopt: "overwrite"}
    plotly.plot(data, graphOptions, function (err, msg) {
        puts msg
        puts err

RunAlgo(AlgoType.STATIC, 'csv/BTC.csv', '2017-01-17', '2017-02-19')
