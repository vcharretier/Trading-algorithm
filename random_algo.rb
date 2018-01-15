# Algo random
class RandomAlgo
  TRANSACTION_VALUE = 1000

  def initialize(param_account)
    @account = param_account
  end

  def update(current_exchange_rate_usd)
    if Math.random < 0.5
      @account.buy(TRANSACTION_VALUE, current_exchange_rate_usd)
    else
      @account.sell(TRANSACTION_VALUE, current_exchange_rate_usd)
    end
  end
end
