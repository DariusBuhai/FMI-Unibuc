import admin.app as admin_app
app = admin_app.app
if __name__ == "__main__":
    app.run(host='127.0.0.1', port=8080, debug=True)