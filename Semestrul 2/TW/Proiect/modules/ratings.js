const fs = require("fs");

class Ratings {

    get() {
        let data = JSON.parse(fs.readFileSync("data/ratings.json"));
        return data;
    }

    /// post and update
    post(ip, product_id, criteria, value) {
        var ratings = this.get()[product_id][criteria];
        var found = false;
        ratings[ip]=value;
        fs.writeFileSync("data/ratings.json", JSON.stringify(ratings));
        return ratings;
    }
}

module.exports = Ratings;