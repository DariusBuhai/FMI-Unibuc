import requests
from flask import Flask, render_template, jsonify, request

from blockchain import VOTING_OPTIONS
from client import Client

app = Flask(__name__)


# App
@app.route('/')
def index():
    client = Client()
    return render_template('index.html',
                           public_key=client.public_key,
                           private_key=client.private_key,
                           voting_options=VOTING_OPTIONS
                           )


# API
@app.route('/post/generate/transaction', methods=['POST'])
def generateTransaction():
    receiver = request.form['receiver']
    private_key = request.form['private_key']
    public_key = request.form['public_key']

    client = Client(private_key, public_key)
    response = client.createTransaction(receiver)
    if response is None:
        return jsonify("None"), 400

    try:
        return jsonify(response.json()), response.status_code
    except:
        return jsonify("None"), 400


@app.route('/get/available_funds/<address>', methods=['GET'])
def getAvailableFunds(address):
    response = Client.getAvailableFunds(address)
    if response is None:
        return jsonify("None"), 400
    try:
        return jsonify(response.json()), response.status_code
    except:
        return jsonify("None"), 400

# if __name__ == '__main__':
#     app.run(host='127.0.0.1', port=8000)
