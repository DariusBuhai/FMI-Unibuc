var categories = [];
var selected_category = null;
var bill = {};

function get_categories(callback = null){
    http_get("categories", function(data){
        categories = data;
        if(selected_category==null) selected_category = categories[0];
        var category_template = document.getElementById("category-template");
        var categories_template = document.getElementById("categories");
        categories_template.innerHTML = "";
        for(var i=0;i<data.length;i++){
            let category = generate_child_from_template(category_template.cloneNode(true), {
                name: data[i],
                active: (data[i]===selected_category) ? "active" : "",
                id: i
            });
            category.id = "";
            categories_template.appendChild(category);
        }
        if(callback)
            callback();
    });
}

function change_category(id){
    let c = document.getElementsByClassName("category-item");
    for(let i=0;i<c.length;i++)
        c[i].classList.remove("active");
    document.getElementsByClassName("category-item-"+id)[0].classList.add("active");
    selected_category = categories[id];
    get_products(function(){
        get_bill();
    });
}


function get_products(callback = null){
    http_get("products/"+selected_category, function(data){
        var product_template = document.getElementById("product-template");
        var products_template = document.getElementById("products");
        products_template.innerHTML = "";
        for(let i=0;i<data.length;i++){
            let product = generate_child_from_template(product_template.cloneNode(true), {
                title: data[i].name,
                image: "images/"+data[i].image,
                description: data[i].description,
                price: data[i].price,
                id: data[i].id
            });
            products_template.appendChild(product);
        }
        if(callback)
            callback();
    });
}

function generate_product_details(product_id, template, callback){
    http_get("/product/"+product_id, async function(data){
        let modal = generate_child_from_template(template.cloneNode(true), {
            title: data["name"],
            description: data["description"],
            image: "images/"+data["image"],
            price: data["price"],
            category: data["category"],
            id: product_id
        });
        callback(modal)
    });
}

function check_password(password, callback){
    http_get("/check_auth/"+password,function(resp){
        callback(resp=="true");
    }, false);
}

function check_user_permissions(admin_mode, callback){
    if(!admin_mode){
        callback();
        return;
    }
    password = prompt("Va rugam sa introduceti parola!");
    check_password(password, function(resp){
        if(resp){
            callback(true);
            window.localStorage.setItem("password", password);
        }else if(password.length>0){
            alert("Parola gresita!");
        }
    });
}

function toggle_admin_mode(admin_mode = true){
    check_user_permissions(admin_mode, function(){
        toggle_hide_by_class("index-content", admin_mode);
        toggle_hide_by_class("admin-content", !admin_mode);
        if(admin_mode) init_admin();
        else init_index();
    });
}

function init_general(){
    strip_transition_blockers();
}

init_general();