require './util.rb'

# Compte...
class Account
  def initialize(funds_usd)
    @funds_usd = funds_usd
    @funds_crypto = 0
    @util = Util.new
  end

  def buy(amount_usd, exchange_rate_usd)
    if (@funds_usd - amount_usd) < 0
    # throw new Error('NotEnoughUSDFundsException');
    # puts "NotEnoughUSDFundsException"
    else
        @funds_usd -= amount_usd
        @funds_crypto +=
          (amount_usd / exchange_rate_usd) -
          (@util.getTransactionFeeUSD(amount_usd) / exchange_rate_usd)
    end
  end

  def sell(amount_usd, exchange_rate_usd)
    if (@funds_crypto - amount_usd / exchange_rate_usd) < 0
    # throw new Error('NotEnoughCryptoFundsException');
    # puts "NotEnoughCryptoFundsException"
    else
        @funds_usd += amount_usd - @util.getTransactionFeeUSD(amount_usd)
        @funds_crypto -= amount_usd / exchange_rate_usd
    end
  end

  def balance_usd(exchange_rate_usd)
    (@funds_crypto * exchange_rate_usd.to_f) + @funds_usd
  end

  attr_reader :funds_usd

  attr_reader :funds_crypto
end
