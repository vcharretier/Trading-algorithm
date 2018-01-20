require('./util.rb')
require('time')

# Pour tracer les courbes...
class PlotData
  def initialize(exchange_rate_usd_history, algorithm_type)
    config = YAML.load_file('./config_plotly.yml')

    @plotly = PlotLy.new(
      config['plotly']['username'],
      config['plotly']['private_key']
    )
    @exchange_rate_usd_history = exchange_rate_usd_history
    @algorithm_type = algorithm_type

    @date_array = []
    @balance_usd_array = []
    @funds_usd_array = []
    @funds_crypto_array = []
    @crypto_value_array = []

    @util = Util.new

    @data = []
  end

  def update(index, account)
    current_date = Time.parse(@exchange_rate_usd_history[index][0])
    @date_array << current_date
    @balance_usd_array.push(
      account.balance_usd(@exchange_rate_usd_history[index]['Close'])
    )
    @funds_usd_array.push(account.funds_usd)
    @funds_crypto_array.push(account.funds_crypto)
    @crypto_value_array.push(@exchange_rate_usd_history[index]['Close'])
  end

  def prepare_data
    balance_usd_data =
      {
        x: @date_array,
        y: @balance_usd_array,
        type: 'scatter',
        name: 'Balance in $'
      }
    funds_usd_data =
      {
        x: @date_array,
        y: @funds_usd_array,
        type: 'scatter',
        name: 'Funds in $'
      }
    funds_crypto_data =
      {
        x: @date_array,
        y: @funds_crypto_array,
        type: 'scatter',
        name: "Funds in \xC9\x83",
        yaxis: 'y2'
      }
    crypto_value_data =
      {
        x: @date_array,
        y: @crypto_value_array,
        # type: "scatter",
        name: "\xC9\x83 value in $"
      }
    @data = [
      balance_usd_data,
      funds_usd_data,
      funds_crypto_data,
      crypto_value_data
    ]
    @layout = {
      title: @algorithm_type,
      yaxis: {
        title: '$',
        domain: [0, 0.65]
      },
      yaxis2: {
        title: "\xC9\x83",
        overlaying: 'y',
        side: 'right'
      }
    }
  end

  attr_reader :exchange_rate_usd_history

  def add_data(arr)
    @data += arr
  end

  attr_reader :date_array

  attr_reader :layout

  def plot_data
    graph_options = {
      layout: @layout,
      filename: 'date-axes',
      fileopt: 'overwrite'
    }
    @plotly.plot(@data, graph_options) do |err, msg|
      puts msg
      puts err
    end
  end
end
