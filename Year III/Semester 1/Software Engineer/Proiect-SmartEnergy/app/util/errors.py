from flask import jsonify, render_template


class NetworkError:
    def __init__(self, title: str, message: str, status: int = 500, error_code=None):
        self.title = title
        self.message = message
        self.status = status
        self.error_code = error_code

    def getResponse(self):
        return jsonify({
            "title": self.title,
            "message": self.message,
            "status": self.status,
            "error_code": self.error_code
        }), self.status

    def __str__(self):
        return self.message

    def __repr__(self):
        return self.message
