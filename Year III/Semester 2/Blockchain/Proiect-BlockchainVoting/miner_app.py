import miner.app as miner_file

app = miner_file.app
if __name__ == "__main__":
    app.run(host=miner_file.host, port=miner_file.PORT, debug=True)
