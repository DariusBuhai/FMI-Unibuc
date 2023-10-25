from .db import db


class Event(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    time = db.Column(db.DateTime(), nullable=False)
    mentions = db.Column(db.String(255))
    data_id = db.Column(db.Integer, db.ForeignKey('data.id', ondelete='cascade'))
    device_id = db.Column(db.Integer, db.ForeignKey('device.id', ondelete='cascade'))

    def json(self):
        return {
            "id": self.id,
            "time": self.time,
            "mentions": self.mentions,
            "data_id": self.data_id,
            "device_id": self.device_id,
        }

    def __repr__(self):
        return '<Device %r %r>' % (self.alias, self.uuid)
