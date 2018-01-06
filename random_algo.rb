def RandomAlgo param_account
    TRANSACTION_VALUE = 1000
    # TO CHANGE
    account = param_account
    def update currentExchangeRateUSD
        if Math.random() < 0.5
            account.buy(TRANSACTION_VALUE,currentExchangeRateUSD)
        else
            account.sell(TRANSACTION_VALUE,currentExchangeRateUSD)
