from datetime import datetime
from flask import Flask, jsonify, request
from flask_cors import CORS

from db.base import Base, Session, engine
from db.models.event import Event


app = Flask(__name__)
CORS(app)

Base.metadata.create_all(engine)
session = Session()

@app.route('/event', methods=["POST"])
def register_event():
    data = request.form
    sensor_id = data.get('sensor_id')
    node_name = data.get('node_name')
    event_info = data.get('event_info')
    values =  data.get('values')
    date = datetime.now()
    
    event = Event(node_name, sensor_id, date, values, event_info)
    session.add(event)
    session.commit()
    return jsonify("Event was sucessfully registered")


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)
    session.close()