# Useful for something... But what ?...
class Util
  def write_file(
    filename,
    rsi_period_value,
    rsi_low_value,
    rsi_high_value,
    balance_usd_value
  )
    writer = if !File.exists_sync(filename)
               csvWriter(headers: %w[RSIPeriod RSILow RSIHigh BalanceUSD])
             else
               csvWriter(sendHeaders: false)
             end
    writer.pipe(fs.createWriteStream(filename, flags: 'a'))
    writer.write(
      RSIPeriod: rsi_period_value,
      RSILow: rsi_low_value,
      RSIHigh: rsi_high_value,
      BalanceUSD: balance_usd_value
    )
    writer.end
  end

  def get_random_int(min, max)
    Math.floor(Math.random * (max - min + 1)) + min
  end

  def get_transaction_fee_usd(amount_usd)
    case amount_usd
    when amount_usd <= 10
      0.99
    when amount_usd > 11 && amount_usd <= 25
      1.49
    when amount_usd > 25 && amount_usd <= 50
      1.99
    when amount_usd > 51 && amount_usd <= 201
      2.99
    else
      amount_usd * 1.49 / 100
    end
  end

  def get_rsi(data)
    if data.length < 2
      puts "RSI period can't be less than 2"
    else
      sum_gain = 0
      sum_loss = 0

      100 - (100 / (1 + check_sum(data, sum_gain, sum_loss)))
    end
  end

  def check_sum(data, sum_gain, sum_loss)
    Array(0..data.length).each do |j|
      change = (data[j + 1].to_f - data[j].to_f).round(2)
      if change < 0
        sum_loss += change.abs
      else
        sum_gain += change
      end
    end
    return 100 if (sum_loss / data.length).zero?
    (sum_gain / data.length) / (sum_loss / data.length)
  end
end
