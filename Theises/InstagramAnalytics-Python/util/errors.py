from flask import jsonify, render_template


class NetworkError:
    def __init__(self, title: str, message: str, status: int = 500, code: str = 'error'):
        self.title = title
        self.message = message
        self.code = code
        self.status = status

    def getResponse(self):
        return jsonify({
            "title": self.title,
            "message": self.message,
            "status": self.status,
            "code": self.code
        }), self.status

    def getHtmlResponse(self):
        return render_template(
            "page-message.html",
            title=self.title,
            message=self.message
        )

    def __str__(self):
        return self.message

    def __repr__(self):
        return self.message
