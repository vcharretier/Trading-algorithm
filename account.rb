require 'util.rb'

util = Util.new

def Account fundsUSD
    fundsUSD = fundsUSD
    fundsCrypto = 0

    def buy amountUSD, exchangeRateUSD
        if (fundsUSD - amountUSD) < 0
            #throw new Error('NotEnoughUSDFundsException');
            puts "NotEnoughUSDFundsException"
        else
            fundsUSD -= amountUSD
            fundsCrypto += (amountUSD/exchangeRateUSD)-(util.getTransactionFeeUSD(amountUSD)/exchangeRateUSD)

    def sell amountUSD, exchangeRateUSD
        if (this.fundsCrypto - amountUSD/exchangeRateUSD) < 0
            #throw new Error('NotEnoughCryptoFundsException');
            puts "NotEnoughCryptoFundsException"
        else
            fundsUSD += amountUSD-util.getTransactionFeeUSD(amountUSD)
            fundsCrypto -= amountUSD/exchangeRateUSD

    def balanceUSD exchangeRateUSD
        return (fundsCrypto*exchangeRateUSD) + this.fundsUSD
