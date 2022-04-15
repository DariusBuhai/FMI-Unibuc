from app.main import initiateFlask
from flask_socketio import SocketIO

if __name__ == "__main__":
    app = initiateFlask()

    # Initiate socket IO app - flask
    socketio = SocketIO(app)
    socketio.run(app, host='localhost', port=8080, use_reloader=True, debug=True)
