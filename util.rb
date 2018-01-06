class Util
  def getTransactionFeeUSD(amountUSD)
    if amountUSD <= 10
      return 0.99
    elsif amountUSD > 11 && amountUSD <= 25
      return 1.49
    elsif(amountUSD > 25 && amountUSD <= 50){
      return 1.99
    elsif(amountUSD > 51 && amountUSD <= 201){
      return 2.99
    return amountUSD * 1.49/100

    def getRSI rsiPeriod, data, currentIndex
      if currentIndex < rsiPeriod
        puts "Not enough data to use RSI "+ rsiPeriod + "-period"
        rsiPeriod = currentIndex
        puts ". RSI period is now " + rsiPeriod

        sumGain = 0
        sumLoss = 0

        for i = currentIndex-rsiPeriod ; i < rsiPeriod ; i++)
            change = data[i+1] - data[i]
            if change < 0
                sumLoss += change
            else
                sumGain += change

        averageGain = (sumGain/rsiPeriod).toFixed(6)
        averageLoss = (sumLoss/rsiPeriod).toFixed(6)
        firstRS = (averageGain/averageLoss).toFixed(6)
        RSI = 100 - (100/(1+firstRS))

        return RSI

module.exports = Util
