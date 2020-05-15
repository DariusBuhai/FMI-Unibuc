const express = require('express');
const path = require('path');
const fs = require('fs');
const bodyParser = require("body-parser");

const app = express();
const port = 80;

const password = "Parola";

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(bodyParser.raw());

const products = require("./modules/products");
const categories = require("./modules/categories");

const _template_dir = __dirname+"/template";
const _images_dir = __dirname+"/data/images";

/** Link static files */
/* Template */
link_directory(_template_dir+"/scripts");
link_directory(_template_dir+"/images", true);
link_directory(_template_dir+"/fontawesome", true, "/fontawesome/");
link_file(_template_dir+"/style.css");

/* Data */
link_directory(_images_dir, true, "/images/");

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
    if(req.params.password!=password){
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
    res.send(products.prototype.get(null, req.params.id));
});

app.put('/product/:id/:password', function(req,res){
    if(req.params.password!=password){
        res.send("Invalid auth params");
        return;
    }
    products.prototype.put(req.params.id, req, res)
});

app.post('/products/:password', function(req,res){
    if(req.params.password!=password){
        res.send("Invalid auth params");
        return;
    }
    products.prototype.post(req, res);
});

app.delete('/product/:id/:password', function(req,res){
    if(req.params.password!=password){
        res.send("Invalid auth params");
        return;
    }
    res.send(products.prototype.delete(req.params.id));
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
function link_file(file_path, get_path = null){
    if(get_path==null){
        file_path.split("/").forEach(function(dir){
            get_path = dir;
        });
        get_path = "/"+get_path;
    }
    app.get(get_path, function(req, res){
       res.sendFile(path.join(file_path));
    });
}

function link_directory(dir, separate_directories = false, sub = "/", ignore_ext = [".html"]){
    fs.readdirSync(path.join(dir)).forEach(function(file) {
        get_path = file;
        if(file.split('.')[0]=="index") get_path = "";
        if(file.split('.').length==1){
            if(separate_directories) link_directory(dir+"/"+file, separate_directories, sub+file+"/");
            else link_directory(dir+"/"+file, separate_directories, sub);
        }else{
            //console.log(sub+get_path);
            link_file(dir+"/"+file, sub+get_path);
            for(var i=0;i<ignore_ext.length;i++)
                if(get_path.search(ignore_ext[i]))
                    link_file(dir+"/"+file, sub+get_path.replace(ignore_ext[i], ""));
        }
    });
}