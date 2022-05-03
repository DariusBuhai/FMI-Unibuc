# Instantiate the Node
from flask import Flask, render_template, request, jsonify, request_started
from flask_cors import CORS
from graphviz import render
from sympy import re
from miner import Miner
import requests

app = Flask(__name__)
CORS(app)
miner = Miner()
IS_SET = False
host = '127.0.0.1'
PORT = 8000


# App
@app.route('/')
def index():
    if not IS_SET:
        return render_template('welcome_page.html')
    return render_template('index.html')


# API
@app.route("/set_miner", methods=['POST'])
def setMiner():
    global IS_SET
    global miner
    # TODO : change when on heroku!
    currentAddress = f"{host}:{PORT}"

    minerType = request.form['miner_type']

    if minerType == "primary":
        miner.FRIENDLY_MINERS = []
        IS_SET = True
    else:
        friendlyMiner = request.form['friendly_miner']
        dataToSend = {"new_miner_address": currentAddress}
        response = requests.post(f"http://{friendlyMiner}/connect_with_friendly_miner", json=dataToSend)
        miner.FRIENDLY_MINERS = response.json()['addresses']
        # print(response.json())
        miner.FRIENDLY_MINERS.append(friendlyMiner)
        IS_SET = True

    return jsonify("ok"), 200


@app.route("/broadcast_new_miner", methods=['POST'])
def broadcastNewMiner():
    global miner
    new_address = request.json['new_miner_address']
    miner.FRIENDLY_MINERS.append(new_address)

    # print(miner.FRIENDLY_MINERS)


@app.route("/connect_with_friendly_miner", methods=['POST'])
def connectWithFriendlyMiner():
    global miner

    newAddress = request.json['new_miner_address']
    oldAddresses = tuple(miner.FRIENDLY_MINERS)
    broadcastData = {"new_miner_address": newAddress}
    miner.FRIENDLY_MINERS.append(newAddress)

    for address in oldAddresses:
        requests.post(f"http://{address}/broadcast_new_miner", json=broadcastData)
    return jsonify({"addresses": list(oldAddresses)}), 200


@app.route('/nodes/get', methods=['GET'])
def getNodes():
    if not IS_SET:
        return jsonify("Miner not set up"), 400
    return jsonify({'nodes': list(miner.miners)}), 200


@app.route('/transactions/new', methods=['POST'])
def newTransaction():
    if not IS_SET:
        return jsonify("Miner not set up"), 400
    values = request.form
    required = ['sender', 'receiver', 'value', 'signature']
    if not all(k in values for k in required):
        return 'Missing values', 400
    transaction_result, message = miner.appendTransaction(values['sender'], values['receiver'],
                                                          values['value'], values['signature'])
    if not transaction_result:
        response = {'message': message}
        return jsonify(response), 406
    else:
        response = {'message': 'Transaction will be added to Block ' + str(transaction_result)}
        return jsonify(response), 200


@app.route('/get/available_funds/<address>', methods=['GET'])
def availableFunds(address):
    if not IS_SET:
        return jsonify("Miner not set up"), 400
    available = 0
    miner.resolveConflicts()
    all_funds = miner.getBlockchainAvailableFunds(miner.blockchain)
    if address in all_funds:
        available = all_funds[address]

    response = {
        'available': available
    }
    return jsonify(response), 200


@app.route('/get/blockchain', methods=['GET'])
def fullChain():
    if not IS_SET:
        return jsonify("Miner not set up"), 400
    response = {
        'chain': miner.blockchain,
        'length': len(miner.blockchain),
    }
    return jsonify(response), 200


@app.route('/nodes/register', methods=['POST'])
def registerNodes():
    if not IS_SET:
        return jsonify("Miner not set up"), 400
    values = request.form
    nodes = values.get('nodes').replace(" ", "").split(',')

    if nodes is None:
        return "Error: Please supply a valid list of nodes", 400
    for node in nodes:
        miner.registerMiner(node)

    response = {
        'message': 'New nodes have been added',
        'total_nodes': [node for node in miner.miners],
    }
    return jsonify(response), 201


@app.route('/resolve/miners/conflicts', methods=['GET'])
def consensus():
    if not IS_SET:
        return jsonify("Miner not set up"), 400
    replaced = miner.resolveConflicts()

    if replaced:
        response = {
            'message': 'Our chain was replaced',
            'new_chain': miner.blockchain
        }
    else:
        response = {
            'message': 'Our chain is authoritative',
            'chain': miner.blockchain
        }
    return jsonify(response), 200


@app.route("/update_miner", methods=['GET'])
def updateMiner():
    if not IS_SET:
        return jsonify("Miner not set up"), 400
    status = miner.runMiner()
    if status:
        return jsonify("ok"), 200
    else:
        return jsonify("not ok"), 400

# if __name__ == '__main__':
#     app.run(host=host, port=port)
