require('./util.rb')
require 'openssl'
require 'yaml'
require('plotly')

# Data pour algo RSI
class RSIData
  def initialize(plot_basic_data, rsi_period, rsi_high_value, rsi_low_value)
    @plot_basic_data = plot_basic_data
    @exchange_rate_usd_history = @plot_basic_data.exchange_rate_usd_history
    @rsi_low_array = []
    @rsi_low_date_array = []
    @rsi_high_array = []
    @rsi_high_date_array = []
    @rsi_value_array = []
    @rsi_value_date_array = []
    @rsi_lower_line_array = []
    @rsi_higher_line_array = []

    @rsi_period = rsi_period
    @rsi_high_value = rsi_high_value
    @rsi_low_value = rsi_low_value

    @util = Util.new
  end

  def update(index)
    current_date = DateTime.parse(@exchange_rate_usd_history[index][0])
    if index >= @rsi_period
      last_rsi_period_length_price = []
      Array(index - @rsi_period..index).each do |k|
        last_rsi_period_length_price << @exchange_rate_usd_history[k]['Close']
      end
      rsi = compute_rsi(last_rsi_period_length_price, index, current_date)
      @rsi_value_array.push(rsi)
      @rsi_value_date_array.push(current_date)
    end
    @rsi_lower_line_array.push(@rsi_low_value)
    @rsi_higher_line_array.push(@rsi_high_value)
  end

  def compute_rsi(last_rsi_period_length_price, index, current_date)
    rsi = @util.get_rsi(last_rsi_period_length_price)
    if rsi < @rsi_low_value
      @rsi_low_array.push(@exchange_rate_usd_history[index]['Close'])
      @rsi_low_date_array.push(current_date)
    elsif rsi > @rsi_high_value
      @rsi_high_array.push(@exchange_rate_usd_history[index]['Close'])
      @rsi_high_date_array.push(current_date)
    end
  end

  def prepare_data
    rsi_low_data =
      {
        x: @rsi_low_date_array,
        y: @rsi_low_array,
        mode: 'markers',
        type: 'scatter',
        name: 'RSI-' + @rsi_period.to_s + ' below ' + @rsi_low_value.to_s
      }
    rsi_high_data =
      {
        x: @rsi_high_date_array,
        y: @rsi_high_array,
        mode: 'markers',
        type: 'scatter',
        name: 'RSI-' + @rsi_period.to_s + ' above ' + @rsi_high_value.to_s
      }
    rsi_value_data = {
      x: @rsi_value_date_array,
      y: @rsi_value_array,
      type: 'scatter',
      name: 'RSI-' + @rsi_period.to_s + ' value',
      yaxis: 'y3',
      xaxis: 'x'
    }
    rsi_higher_line_data = {
      x: @plot_basic_data.date_array,
      y: @rsi_higher_line_array,
      type: 'scatter',
      yaxis: 'y3',
      xaxis: 'x'
    }
    rsi_lower_line_data = {
      x: @plot_basic_data.date_array,
      y: @rsi_lower_line_array,
      type: 'scatter',
      yaxis: 'y3',
      xaxis: 'x'
    }
    @plot_basic_data.add_data(
      [
        rsi_low_data,
        rsi_high_data,
        rsi_value_data,
        rsi_higher_line_data,
        rsi_lower_line_data
      ]
    )

    @plot_basic_data.layout[:yaxis3] = {
      title: 'RSI',
      domain: [0.75, 1]
    }
  end
end
