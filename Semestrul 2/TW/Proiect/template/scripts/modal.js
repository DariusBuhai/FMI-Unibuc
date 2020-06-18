var opened_modal_id = "";

function show_generated_modal(modal_id, modal){
    opened_modal_id = modal_id;
    modal.id = modal_id;
    modal.hidden = false;
    document.getElementsByTagName("body")[0].appendChild(modal);
    document.getElementById("modal-overlay").hidden = false;
}

function show_modal(modal_id, modal_generator){
    let modal_template = document.getElementById(modal_id+"-template").cloneNode(true);
    if(modal_generator){
        modal_generator(modal_template, function(modal){
            show_generated_modal(modal_id, modal);
        });
    }else show_generated_modal(modal_id, modal_template);
}

function hide_modal(modal_id=null){
    if(modal_id==null) modal_id = opened_modal_id;
    document.getElementById(modal_id).classList.add("hide");
    document.getElementById("modal-overlay").classList.add("hide");
    setTimeout(function(){
        document.getElementById("modal-overlay").classList.remove("hide");
        document.getElementById(modal_id).remove();
        document.getElementById("modal-overlay").hidden = true;
    }, 300);
}