from flask import Blueprint, send_from_directory, redirect

app_general = Blueprint('general', __name__)


# Pages
@app_general.route('/')
def index():
    return "This API works"


# Assets
@app_general.route('/assets/<path:path>')
def serveAssets(path):
    return send_from_directory('templates/assets', path)
