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
    data = request.get_json()
    sensor = data.get('sensor')
    node_name = data.get('node_name')
    event_info = data.get('event_info')
    values =  bool(data.get('values'))
    date = datetime.now()
    event = Event(node_name, sensor, date, values, event_info)
    
    try:
        session.add(event)
        session.commit()
    except:
        print("failed to insert event")
        session.rollback()
        return jsonify("Failed to insert event")
        
    return jsonify("Event was sucessfully registered")


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
    session.close()
    