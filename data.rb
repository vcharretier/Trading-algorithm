require 'csv'

class DataCurrency
    def initialize(filename)
        @filename = filename
        @history = File.read(@filename)
    end
end
# // Data.prototype.getBuyPrice = function(startDate, endDate){
# //     return jsonQuery('[* Date <= '+startDate+' & Date <= '+endDate+']', {
# //     data: this.history
# //     }).value
# // };
