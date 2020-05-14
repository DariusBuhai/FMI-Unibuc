function strip_transition_blockers(){
    var el = document.getElementsByClassName("no-transition");
    for(var i=0;i<el.length;i++)
        el[i].classList.remove("no-transition");
}

function toggle_bill_view(hide = true){
    if(hide){
        document.getElementById("bill-view").classList.add("hide");
        document.getElementById("bill-overlay").classList.add("hide");
        setTimeout(function(){
            document.getElementById("bill-view").hidden = true;
            document.getElementById("bill-overlay").hidden = true;
        }, 300);
    }else{
        document.getElementById("bill-view").classList.remove("hide");
        document.getElementById("bill-overlay").classList.remove("hide");
        document.getElementById("bill-view").hidden = false;
        document.getElementById("bill-overlay").hidden = false;
    }
}