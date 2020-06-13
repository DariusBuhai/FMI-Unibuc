var categories = [];
var selected_category = null;
var bill = {};
var marked_products = {};
var last_markup = null;

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


async function get_products(callback = null){
    http_get("products/"+selected_category, async function(data){
        var product_template = document.getElementById("product-template");
        var products_template = document.getElementById("products");
        products_template.innerHTML = "";
        for(let i=0;i<data.length;i++){
            let rating = await get_rating(data[i].id);
            var description = data[i].description;
            console.log(rating);
            if(marked_products && marked_products.hasOwnProperty(data[i].id)){
                var new_description = description.slice(0,marked_products[data[i].id].from);
                new_description += "<mark>";
                new_description += description.slice(marked_products[data[i].id].from, marked_products[data[i].id].to);
                new_description += "</mark>";
                new_description += description.slice(marked_products[data[i].id].to, description.length);
                description = new_description;
            }
            let product = generate_child_from_template(product_template.cloneNode(true), {
                title: data[i].name,
                image: "images/"+data[i].image,
                description: description,
                price: data[i].price,
                id: data[i].id,
                rating_1: (rating>=1 ? "active" : ""),
                rating_2: (rating>=2 ? "active" : ""),
                rating_3: (rating>=3 ? "active" : ""),
                rating_4: (rating>=4 ? "active" : ""),
                rating_5: (rating>=5 ? "active" : ""),
            });
            products_template.appendChild(product);
        }
        if(callback)
            callback();
    });
}

async function generate_product_details(product_id, template, callback, include_markup = true){
    http_get("/product/"+product_id, async function(data){
        let rating1 = await  get_rating(product_id, 1);
        let rating2 = await  get_rating(product_id, 2);
        let rating3 = await  get_rating(product_id, 3);
        var description = data["description"];
        if(include_markup && marked_products && marked_products.hasOwnProperty(product_id)){
            var new_description = description.slice(0,marked_products[product_id].from);
            new_description += "<mark>";
            new_description += description.slice(marked_products[product_id].from, marked_products[product_id].to);
            new_description += "</mark>";
            new_description += description.slice(marked_products[product_id].to, description.length);
            description = new_description;
        }
        var template_data = {
            title: data["name"],
            description: description,
            image: "images/"+data["image"],
            price: data["price"],
            category: data["category"],
            id: product_id
        };
        for(var i=1;i<=3;i++)
            for(var j=1;j<=5;j++){
                var v = 0;
                if(i===1) v = rating1;
                if(i===2) v = rating2;
                if(i===3) v = rating3;
                template_data["rating_"+i+"_"+j] = (v>=j ? "active" : "");
            }
        let modal = generate_child_from_template(template.cloneNode(true), template_data);
        callback(modal);
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
    let password = prompt("Va rugam sa introduceti parola!");
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
get_products_markup();

/**
 * Markup
 * Task 4 - P4
 * 2 pct
 */

function get_products_markup(){
    marked_products = JSON.parse(window.localStorage.getItem("marked_products"));
    if(marked_products==null){
        marked_products = {};
    }
    get_products();
}

function apply_markup(){
    if(last_markup==null) return;
    if(marked_products && marked_products.hasOwnProperty(last_markup.product_id)){
        delete marked_products[last_markup.product_id];
        get_products();
        return;
    }
    console.log(last_markup);
    console.log(marked_products);
    marked_products[last_markup.product_id] = {from: last_markup.from,to: last_markup.to};
    last_markup = null;
    get_products();
    window.localStorage.setItem("marked_products", JSON.stringify(marked_products));
}

function update_product_markup(product_id){
    var marked = window.getSelection();
    var from = marked.anchorOffset;
    var to = marked.focusOffset;
    if(from>to){
        var aux = from;
        from = to;
        to = aux;
    }
    last_markup = {product_id, from, to};
}

function refresh_products() {
    var evtobj = window.event? event : e;
    if (evtobj.keyCode === 91 || evtobj.keyCode===17){
        apply_markup();
    }
}

/**
 * Task 4 - P2
 * 2 pct
 * Rating functions
 **/
async function get_rating(product_id, criteria=null){
    var link = "/ratings/"+product_id;
    if(criteria!=null) link += "/"+criteria;
    return parseInt(await http_get_async(link));
}

function update_rating(value, product_id, criteria){
    http_post("/ratings", {
        product_id: product_id,
        criteria: criteria,
        value: value
    }, function(res){

    });
    get_products();

}
