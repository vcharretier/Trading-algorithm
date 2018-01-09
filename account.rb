require './util.rb'


class Account

    def initialize fundsUSD
      @fundsUSD = fundsUSD
      @fundsCrypto = 0
      @util = Util.new
    end

    def buy amountUSD, exchangeRateUSD
        if (@fundsUSD - amountUSD) < 0
            #throw new Error('NotEnoughUSDFundsException');
            #puts "NotEnoughUSDFundsException"
        else
            @fundsUSD -= amountUSD
            @fundsCrypto += (amountUSD/exchangeRateUSD)-(@util.getTransactionFeeUSD(amountUSD)/exchangeRateUSD)
        end
    end

    def sell amountUSD, exchangeRateUSD
        if (@fundsCrypto - amountUSD/exchangeRateUSD) < 0
            #throw new Error('NotEnoughCryptoFundsException');
            #puts "NotEnoughCryptoFundsException"
        else
            @fundsUSD += amountUSD-(@util.getTransactionFeeUSD(amountUSD))
            @fundsCrypto -= amountUSD/exchangeRateUSD
        end
    end

    def balanceUSD exchangeRateUSD
        return (@fundsCrypto*exchangeRateUSD.to_f) + @fundsUSD
    end

    def fundsUSD
      @fundsUSD
    end

    def fundsCrypto
      @fundsCrypto
    end
end
