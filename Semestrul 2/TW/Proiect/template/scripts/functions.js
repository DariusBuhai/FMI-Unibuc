function generate_child_from_template(template, data){
    let outer_template = document.createElement("div");
    template.hidden = false;
    template.removeAttribute("id");
    outer_template.appendChild(template);
    for (const [key, value] of Object.entries(data))
        outer_template.innerHTML = outer_template.innerHTML.split("[["+key+"]]").join(value);
    return outer_template.childNodes[0];
}

function http_get(theUrl, callback, json_data = true) {
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.onreadystatechange = function() {
        if (xmlHttp.readyState === 4 && xmlHttp.status === 200){
            if(!json_data) callback(xmlHttp.responseText);
            else callback(JSON.parse(xmlHttp.responseText));
        }
    };
    xmlHttp.open("GET", theUrl, true); // true for asynchronous
    xmlHttp.setRequestHeader("accepts", "application/json");
    xmlHttp.send(null);
}

async function http_get_async(theUrl, json_data = true){
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.open("GET", theUrl, false); // true for asynchronous
    xmlHttp.setRequestHeader("accepts", "application/json");
    xmlHttp.send(null);
    if (xmlHttp.readyState === 4 && xmlHttp.status === 200){
        if(!json_data) return xmlHttp.responseText;
        else return JSON.parse(xmlHttp.responseText);
    }
}

function http_post(theUrl, data, callback, isFormData = false) {
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.onreadystatechange = function() {
        if (xmlHttp.readyState === 4 && xmlHttp.status === 200){
            callback(xmlHttp.responseText);
        }
    };
    xmlHttp.open("POST", theUrl);
    if(isFormData){
        var formData = new FormData();
        for(const [key, value] of Object.entries(data))
            formData.append(key, value);
        xmlHttp.send(formData);
    }else{
        xmlHttp.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
        xmlHttp.send(JSON.stringify(data));
    }
}

function http_put(theUrl, data, callback, isFormData) {
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.onreadystatechange = function() {
        if (xmlHttp.readyState === 4 && xmlHttp.status === 200){
            callback(xmlHttp.responseText);
        }
    };
    xmlHttp.open("PUT", theUrl);
    if(isFormData){
        var formData = new FormData();
        for(const [key, value] of Object.entries(data))
            formData.append(key, value);
        xmlHttp.send(formData);
    }else{
        xmlHttp.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
        xmlHttp.send(JSON.stringify(data));
    }
}

function http_delete(theUrl, callback) {
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.onreadystatechange = function() {
        if (xmlHttp.readyState == 4 && xmlHttp.status == 200){
            callback(xmlHttp.responseText);
        }
    };
    xmlHttp.open("DELETE", theUrl);
    xmlHttp.send();
}

function toggle_hide_by_class(className, hide = true){
    let el = document.getElementsByClassName(className);
    for(let i=0;i<el.length;i++)
        el[i].hidden= hide;
}

function changed_image(input_id, image_id){
    let file = document.getElementById(input_id).value;
    let img = document.getElementById(image_id);

    var tgt = file.target || window.event.srcElement, files = tgt.files;

    if (FileReader && files && files.length) {
        var fr = new FileReader();
        fr.onload = function () {
            img.src = fr.result;
        };
        fr.readAsDataURL(files[0]);
    }
}

function toggle_expand_navbar(){
    let nav = document.getElementById("navbar");
    if(nav.classList.contains("expanded")){
        nav.classList.remove("expanded");
        return;
    }
    nav.classList.add("expanded");
}

function open_page(link){
    console.log(link);
    location.href = link;
}