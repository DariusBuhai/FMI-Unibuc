const express = require('express');
const path = require('path');
const fs = require('fs');
const bodyParser = require("body-parser");

const app = express();
const port = 3000;

const password = "Parola";

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(bodyParser.raw());

const products = require("./modules/products");
const categories = require("./modules/categories");
const logger = require("./modules/logger");

const _template_dir = __dirname+"/template";
const _images_dir = __dirname+"/data/images";

/** Link static files */
/* Template */
link_folder(_template_dir+"/scripts");
link_folder(_template_dir+"/images", true);
link_folder(_template_dir+"/fontawesome", true, "/fontawesome/");
link_path(_template_dir+"/style.css");

/* Data */
link_folder(_images_dir, true, "/images/");

/** */
app.get('/', function(req, res){
    res.sendFile(_template_dir+"/index.html");
});

app.get('/random', function(req, res){
    res.sendFile(_template_dir+"/random.html");
});

/** Data getters and setters */
/** Categories */
app.get('/categories', function(req,res){
    res.send(categories.prototype.get());
});

app.get('/categories/:id', function(req,res){
    res.send(categories.prototype.get(req.params.id));
});

app.delete('/categories/:name/:password', function(req,res){
    if(req.params.password!==password){
        res.send("Invalid auth params");
        return;
    }
    res.send(categories.prototype.delete(req.params.name));
});

/** Products */
app.get('/products', function(req,res){
    res.send(products.prototype.get());
});

app.get('/products/:category', function(req,res){
    res.send(products.prototype.get(req.params.category));
});

app.get('/product/:id', function(req,res){
    if(req.header("accepts")==="application/json"){
        res.send(products.prototype.get(null, req.params.id));
    }else{
        res.sendFile(_template_dir+"/product.html");
    }
    /** Log action */
    logger.prototype.post(req.ip,"Viewed the product with id "+req.params.id);
});

app.put('/product/:id/:password', function(req,res){
    if(req.params.password!==password){
        res.send("Invalid auth params");
        /** Log action */
        logger.prototype.post(req.ip,"Attempted to modify products, but with invalid auth params!");
        return;
    }
    products.prototype.put(req.params.id, req, res)
    /** Log action */
    logger.prototype.post(req.ip,"Edited the product with id "+req.params.id);
});

app.post('/products/:password', function(req,res){
    if(req.params.password!==password){
        res.send("Invalid auth params");
        /** Log action */
        logger.prototype.post(req.ip,"Attempted to modify products, but with invalid auth params!");
        return;
    }
    products.prototype.post(req, res);
    /** Log action */
    logger.prototype.post(req.ip,"Created a new product");
});

app.delete('/product/:id/:password', function(req,res){
    if(req.params.password!==password){
        res.send("Invalid auth params");
        /** Log action */
        logger.prototype.post(req.ip,"Attempted to modify products, but with invalid auth params!");
        return;
    }
    res.send(products.prototype.delete(req.params.id));
    /** Log action */
    logger.prototype.post(req.ip,"Deleted the product with id "+req.params.id);
});

/** Logger */
app.get('/logger', function(req,res){
    if(req.header("accepts")==="application/json"){
        res.send(logger.prototype.get());
    }else{
        res.send(logger.prototype.get_string());
    }
});

/** Check password */
app.get('/check_auth/:password', function(req, res){
    let isCorrect = req.params.password===password;
    res.send(isCorrect);
});

/** 404 Error redirect */
app.use(function(req, res, next){
    res.status(404);
    res.sendFile(_template_dir+"/404.html");
});

/** Start local server */
app.listen(port, () =>
    console.log("Server started at: localhost:"+port)
);

/** Usefull functions */
function link_path(file_location, get_prefix = null){
    if(get_prefix==null){
        file_location.split("/").forEach(function(dir){
            get_prefix = dir;
        });
        get_prefix = "/"+get_prefix;
    }
    app.get(get_prefix, function(req, res){
       res.sendFile(path.join(file_location));
    });
}

function link_folder(dir, separate_directories = false, sub = "/", ignore_extension = [".html"]){
    fs.readdirSync(path.join(dir)).forEach(function(file) {
        get_prefix = (file.split('.')[0]==="index") ? "" : file;
        if(file.split('.').length===1){
            if(separate_directories) link_folder(dir+"/"+file, separate_directories, sub+file+"/");
            else link_folder(dir+"/"+file, separate_directories, sub);
            return;
        }
        link_path(dir+"/"+file, sub+get_prefix);
        for(var i=0;i<ignore_extension.length;i++)
            if(get_prefix.search(ignore_extension[i]))
                link_path(dir+"/"+file, sub+get_prefix.replace(ignore_extension[i], ""));
    });
}