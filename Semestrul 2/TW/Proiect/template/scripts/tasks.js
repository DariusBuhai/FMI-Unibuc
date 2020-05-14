setInterval(function(){
    updateAge();
}, 1000);

function updateAge(){
    var birthday = document.getElementById("age-calculator").value;
    if(!Date.parse(birthday)) return;
    var diff = Date.now()-Date.parse(birthday);
    var date_diff = new Date(diff);
    let res = date_diff.getFullYear()-1970+" ani "+date_diff.getMonth()+" luni "+date_diff.getDay()+" zile "+date_diff.getHours()+" de ore, "+date_diff.getMinutes()+" minute si "+date_diff.getSeconds()+" secunde";
    document.getElementById("age-generated").innerText = res;
    document.getElementById("age-has-generated").hidden = false;
}