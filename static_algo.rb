# Static Algo
class StaticAlgo
  def initialize(account)
    @account = account
    @already_bought = false
  end

  def update(current_exchange_rate_usd)
    return if @already_bought
    account.buy(account.fundsUSD, current_exchange_rate_usd)
    @already_bought
  end
end
