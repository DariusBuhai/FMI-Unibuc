from werkzeug.security import generate_password_hash, check_password_hash

from .db import db


class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(255), unique=True, nullable=False)
    email = db.Column(db.String(255), unique=True, nullable=False)
    password = db.Column(db.String(255), nullable=False)
    devices = db.relationship('Device', backref='user')

    def json(self):
        return {
            "id": self.id,
            "username": self.username,
            "email": self.email
        }

    def set_password(self, password):
        """Create hashed password."""
        self.password = generate_password_hash(
            password,
            method='sha256'
        )

    def check_password(self, password):
        """Check hashed password."""
        return check_password_hash(self.password, password)

    def __repr__(self):
        return '<User %r %r>' % (self.username, self.email)
