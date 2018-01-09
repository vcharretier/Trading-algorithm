require 'csv'

class DataCurrency
    def initialize(filename)
        @filename = filename
        @history = CSV.read(@filename, headers:true)
    end

    def history
      @history
    end
end
# // Data.prototype.getBuyPrice = function(startDate, endDate){
# //     return jsonQuery('[* Date <= '+startDate+' & Date <= '+endDate+']', {
# //     data: this.history
# //     }).value
# // };
