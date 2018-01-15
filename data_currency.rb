require('csv')

# Ouvre fichier csv
class DataCurrency
  def initialize(filename)
    @filename = filename
    @history = CSV.read(@filename, headers: true)
  end

  attr_reader :history
end
