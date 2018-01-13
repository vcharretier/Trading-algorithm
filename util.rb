class Util
  def writeFile filename, rsi_period_value, rsi_low_value, rsi_high_value, balanceUSDValue
      if !File.existsSync(filename)
          writer = csvWriter({ headers: ["RSIPeriod", "RSILow", "RSIHigh","BalanceUSD"]})
      else
          writer = csvWriter({sendHeaders: false})
      end
      writer.pipe(fs.createWriteStream(filename, {flags: 'a'}))
      writer.write({RSIPeriod: RSIPeriodValue, RSILow:RSILowValue, RSIHigh:RSIHighValue, BalanceUSD:balanceUSDValue})
      writer.end()
  end

  def getRandomInt min, max
      return Math.floor(Math.random() * (max - min + 1)) + min
  end

  def getTransactionFeeUSD amountUSD
    if amountUSD <= 10
      return 0.99
    elsif amountUSD > 11 && amountUSD <= 25
      return 1.49
    elsif amountUSD > 25 && amountUSD <= 50
      return 1.99
    elsif amountUSD > 51 && amountUSD <= 201
      return 2.99
    end
    return amountUSD * 1.49/100
  end

    def getRSI data
      if data.length < 2
          #throw new Error("RSI period can't be less than 2");
          puts "RSI period can't be less than 2"
      else
        sumGain = 0
        sumLoss = 0

        for j in 0 ... data.length-1
            change = (data[j+1].to_f - data[j].to_f).round(2)
            if change < 0
                sumLoss += change.abs
            else
                sumGain += change
            end
        end

        averageGain = (sumGain/data.length)
        averageLoss = (sumLoss/data.length)

        if averageLoss == 0
            firstRS = 100
        else
            firstRS = averageGain/averageLoss
        end

        return 100 - (100/(1+firstRS))
      end
    end
end
