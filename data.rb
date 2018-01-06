var loader = require('csv-load-sync');
var jsonQuery = require('json-query')

def Data filename
    filename = filename
    history = loader(filename)

# // Data.prototype.getBuyPrice = function(startDate, endDate){
# //     return jsonQuery('[* Date <= '+startDate+' & Date <= '+endDate+']', {
# //     data: this.history
# //     }).value
# // };
