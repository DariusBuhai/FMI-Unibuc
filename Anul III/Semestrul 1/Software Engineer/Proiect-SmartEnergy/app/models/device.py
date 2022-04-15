from .db import db


class Device(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    alias = db.Column(db.String(255), nullable=False)
    uuid = db.Column(db.String(255), unique=True, nullable=False)
    description = db.Column(db.String(255), nullable=False)
    status = db.Column(db.Boolean(), nullable=False, default=False)
    settings = db.Column(db.JSON())
    data = db.relationship('Data', backref='device', lazy=True)
    events = db.relationship('Event', backref='device', lazy=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id', ondelete='cascade'))

    def json(self):
        return {
            "id": self.id,
            "alias": self.alias,
            "uuid": self.uuid,
            "description": self.description,
            "status": self.status,
            "settings": self.settings
        }

    def __repr__(self):
        return '<Device %r %r>' % (self.alias, self.uuid)
