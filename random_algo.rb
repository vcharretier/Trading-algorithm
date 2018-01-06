class RandomAlgo
    TRANSACTION_VALUE = 1000

    def initialize param_account
      @account = param_account

    def update currentExchangeRateUSD
        if Math.random() < 0.5
            @account.buy(TRANSACTION_VALUE,currentExchangeRateUSD)
        else
            @account.sell(TRANSACTION_VALUE,currentExchangeRateUSD)
