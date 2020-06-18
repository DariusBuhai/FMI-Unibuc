function edit_product(product_id){
    let password = window.localStorage.getItem("password");

    let new_title = document.getElementById("product_"+product_id+"_title").value;
    let new_description = document.getElementById("product_"+product_id+"_description").value;
    let new_price = document.getElementById("product_"+product_id+"_price").value;
    let new_image = document.getElementById("product_"+product_id+"_image").files[0];
    let new_category = document.getElementById("product_"+product_id+"_category").value;

    http_put("product/"+product_id+"/"+password, {
        name: new_title,
        description: new_description,
        price: new_price,
        image: new_image,
        category: new_category
    }, function(res){
        console.log(res);
        get_products();
        hide_modal('edit-product-modal')
    }, true);
}

function add_product(){
    let password = window.localStorage.getItem("password");
    http_post("products"+"/"+password, {
        name: document.getElementById("product_title").value,
        description: document.getElementById("product_description").value,
        image: document.getElementById("product_image").files[0],
        category: document.getElementById("product_category").value,
        price: document.getElementById("product_price").value
    }, function(res){
        setTimeout(function(){
            get_categories(function(){
                get_products();
            });
        }, 1000);
        hide_modal('add-product-modal')
    }, true);
}

function delete_product(product_id){
    let password = window.localStorage.getItem("password");
    var r = confirm("Esti sigur ca doresti sa stergi acest produs?");
    if(r) {
        http_delete("product/" + product_id+"/"+password, function (res) {
            get_categories(function(data){
                if(!categories.includes(selected_category)) selected_category = categories[0];
                get_products();
            });
            hide_modal('edit-product-modal')
        });
    }
}

/** Deprecated */
function delete_category(){
    let password = window.localStorage.getItem("password");
    var r = confirm("Esti sigur ca doresti sa stergi acesta categorie?");
    if(r){
        http_delete("categories/"+selected_category+"/"+password, function (data) {
            for(var i=0;i<categories.length;i++)
                if(categories[i]!==selected_category){
                    selected_category = categories[i];
                    break;
                }
            get_categories();
            get_products();
        });
    }
}

function init_admin(){
    get_categories(function () {
        get_products();
    });
}