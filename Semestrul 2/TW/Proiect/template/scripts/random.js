/**
 * Game
 * Task 6 - P6
 * 3 pct
 */
var trexUp = false;
var timePassed = 0;
var obstacles = [];
var score = 0;
var gameStarted = false;
var gameInterval;
var trexMoveInterval;

const x1_limit = 40, x2_limit = window.screen.width-80, y1_limit = 155,y2_limit = 500;

let coin = document.createElement("img");
coin.src = "/coin.png";
coin.style.width = "40px";
coin.style.left = "100%";
coin.style.position = "absolute";
coin.addEventListener("click", random_request)
coin.onclick = random_request;

let cactus = document.createElement("img");
cactus.src = "/cactus.png";
cactus.style.width = "40px";
cactus.style.left = "100%";
cactus.style.position = "absolute";
cactus.addEventListener("click", random_request)
cactus.onclick = random_request;

function random_request(){
    console.log("random request");
    score-=1;
    document.getElementById("trex").style.top = "155px";
    trexUp = false;
}

function pause_game(){
    clearInterval(gameInterval);
}

function on_frame(duration = 20){
    if(timePassed>=1000){
        timePassed = 0;
        var obstacle;
        if(get_rnd_integer(0,2)==1)
            obstacle = coin.cloneNode(true)
        else
            obstacle = cactus.cloneNode(false);
        obstacles.push(obstacle);
        document.getElementById("game-generate").appendChild(obstacle);
    }
    for(var i=0;i<obstacles.length;i++){
        let oml = parseInt(obstacles[i].style.left.replace("%", ""));
        if(obstacles[i].src.search("coin")==-1){
            if(oml<=5 && !trexUp)
                game_end();
        }else{
            if(oml<=5 && !trexUp){
                score+=10;
                document.getElementById("game-generate").removeChild(obstacles[i]);
                obstacles.splice(i, 1);
                continue;
            }
        }
        if(oml<=0){
            document.getElementById("game-generate").removeChild(obstacles[i]);
            obstacles.splice(i, 1);
            continue;
        }
        if(obstacles[i]!=undefined)
            obstacles[i].style.left = oml-.4+"%";
    }
    document.getElementById("show-game-score").hidden = false;
    document.getElementById("game-score").innerText = score;
    timePassed+=duration;
}

function get_rnd_integer(min, max) {
    return Math.floor(Math.random() * (max - min) ) + min;
}

function game_end(){
    gameStarted = false;
    document.getElementById("game-message").hidden = false;
    document.getElementById("game-message").innerText = "Game over. Press to start"
    document.getElementById("game-content").hidden = true;
    clearInterval(gameInterval);
    for(var i=0;i<obstacles.length;i++){
        document.getElementById("game-generate").removeChild(obstacles[i]);
    }
    obstacles = [];
}

function game_start(){
    if(!gameStarted){
        score = 0;
        gameStarted = true;
        document.getElementById("game-message").hidden = true;
        document.getElementById("game-content").hidden = false;
        //gameInterval = setInterval(on_frame, 20);
    }
}

function trex_stop_move(){
    console.log("abc");
    if(trexMoveInterval)
        clearInterval(trexMoveInterval);
}

function trex_move(event){
    var x = event.clientX;
    var y = event.clientY;

    let trex = document.getElementById("trex");

    var xt = trex.style.left;
    var yt = trex.style.top;

    let xdiff = x/xt;
    let ydiff = y/yt;

    trexMoveInterval = setInterval(function(){
        let trex = document.getElementById("trex");
        var l = parseInt(trex.style.left.replace("px", ""));
        var t = parseInt(trex.style.top.replace("px", ""));
        if(!l) l=x1_limit;
        if(!t) t=y1_limit;
        console.log(l, x2_limit);
        if(l>=x1_limit && l<=x2_limit)
            trex.style.left=l+1+"px";
        if(t>=y1_limit&&t<=y2_limit)
            trex.style.top=t+1+"px";
    }, 10);
}

/**
 * Age calculator
 * Task 2 - P1
 * 1 pct
 */
/*setInterval(function(){
    update_age();
}, 1000);

function update_age(){
    var birthday = document.getElementById("age-calculator").value;
    if(!Date.parse(birthday)) return;
    var diff = Date.now()-Date.parse(birthday);
    var date_diff = new Date(diff);
    let res = date_diff.getFullYear()-1970+" ani "+date_diff.getMonth()+" luni "+date_diff.getDay()+" zile "+date_diff.getHours()+" de ore, "+date_diff.getMinutes()+" minute si "+date_diff.getSeconds()+" secunde";
    document.getElementById("age-generated").innerText = res;
    document.getElementById("age-has-generated").hidden = false;
}*/