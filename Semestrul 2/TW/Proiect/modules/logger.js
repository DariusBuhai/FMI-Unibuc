const fs = require("fs");
const moment = require("moment");

/**
 * Task 5 - 12
 */

class Logger{

    get(){
        let data = JSON.parse(fs.readFileSync("data/logger.json"));
        return data;
    }

    get_string(){
        let data = this.get();
        var as_string = "";
        for(var i=0;i<data.length;i++){
            as_string += "["+data[i].date+"] ";
            as_string += data[i].ip + " " + data[i].action;
            as_string += "<br>";
        }
        return as_string;
    }

    post(ip, action){
        var data = JSON.parse(fs.readFileSync("data/logger.json"));
        var new_log = {
            date: moment().format('yyyy-mm-dd, hh:mm:ss').toString(),
            ip: ip,
            action: action
        }
        data.push(new_log);
        fs.writeFileSync("data/logger.json", JSON.stringify(data));
    }

}

module.exports = Logger;