def StaticAlgo account
    account = account
    alreadyBought = false
    def update currentExchangeRateUSD
        unless alreadyBought
          account.buy(account.fundsUSD,currentExchangeRateUSD)
          alreadyBought = true

module.exports = StaticAlgo
