from flask import Flask, jsonify
from db.base import scrape

from db.models.humidity import Humidity
from db.models.event import Event
from db.models.temperature import Temperature
from flask_cors import CORS

from db.base import Session

session = Session()

app = Flask(__name__)
CORS(app)

@app.route('/temperature/stored/<records>', methods=["GET"])
def stored_temperature(records):
    temperatures = session.query(Temperature).all()
    nr = int(records)
    result = []
    for temp in temperatures[:nr]:
        result.append({
            'value': float(temp.value),
            'node_name': temp.node_name,
            'sensor_info': temp.sensor_info,
            'date': temp.date
        })
    return jsonify(result)


@app.route('/temperature/<node>', methods=["GET"])
def temperature(node):
    sensor_info, sensor_value = scrape('temperature', node)
    return {
        'sensor_info': sensor_info,
        'node_name': node,
        'sensor_value': sensor_value
    }


@app.route('/humidity/<node>', methods=["GET"])
def humidity(node):
    sensor_info, sensor_value = scrape('humidity', node)
    return {
        'sensor_info': sensor_info,
        'node_name': node,
        'sensor_value': sensor_value
    }


@app.route('/humidity/stored/<records>', methods=["GET"])
def stored_humidity(records):
    humidities = session.query(Humidity).all()
    nr = int(records)
    result = []
    for humidity in humidities[:nr]:
        result.append({
            'value': float(humidity.value),
            'node_name': humidity.node_name,
            'sensor_info': humidity.sensor_info,
            'date': humidity.date
        })
    return jsonify(result)


@app.route('/events/stored/<records>', methods=["GET"])
def events(records):
    events = session.query(Event).all()
    nr = int(records)
    result = []
    events.reverse()
    for event in events[:nr]:
        result.append({
            'node_name': event.node_name,
            'sensor_info': event.sensor_id,
            'date': event.date,
            'event_info': event.event_info
        })
    return jsonify(result)

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)
