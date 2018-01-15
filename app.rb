require('./data_currency.rb')
# require('./random_algo.rb')
require('./simple_algo.rb')
# require('./static_algo.rb')
require('./account.rb')
require('./plot_data.rb')
require('./rsi_data.rb')

def run_algo(algo, account, exchange_rate_usd_histo)
  plot_data = PlotData.new(exchange_rate_usd_histo, algo.name)
  #rsi_data = RSIData.new(plot_data, RSI_PERIOD, RSI_HIGH_VALUE, RSI_LOW_VALUE)

  Array(0...exchange_rate_usd_histo.length).each do |i|
    algo.update(exchange_rate_usd_histo[i]['Close'].to_i)
    plot_data.update(i, account)
    #rsi_data.update(i)
  end
  plot_data.prepare_data
  #rsi_data.prepare_data
  plot_data.plot_data
end

data = DataCurrency.new('csv/BTC_hour.csv')

RSI_LOW_VALUE = 30
RSI_HIGH_VALUE = 70
RSI_PERIOD = 14

account = Account.new(10_000)
exchange_rate_usd_histo = data.history
run_algo(
  SimpleAlgo.new(account, RSI_PERIOD, RSI_LOW_VALUE, RSI_HIGH_VALUE),
  account,
  exchange_rate_usd_histo
)
balance_usd = account.balance_usd(
  exchange_rate_usd_histo[exchange_rate_usd_histo.length - 1]['Close'].to_i
)
puts RSI_PERIOD.to_s +
     ',' + RSI_LOW_VALUE.to_s + ',' + RSI_HIGH_VALUE.to_s + ',' +
     balance_usd.to_s
