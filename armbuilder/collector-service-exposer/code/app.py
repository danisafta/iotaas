from flask import Flask
from db.base import scrape

from db.models.humidity import Humidity
from db.models.pressure import Pressure
from db.models.temperature import Temperature


from db.base import Session

session = Session()

app = Flask(__name__)


@app.route('/temperature/stored/<records>', methods=["GET"])
def stored_temperature(records):

    temperatures = session.query(Temperature).all()
    for temp in temperatures:
        print(temp)

    return {
        'sensor_info': "sensor_info",
        'sensor_value': "sensor_value"
    }


@app.route('/temperature/<node>', methods=["GET"])
def temperature(node):
    sensor_info, sensor_value = scrape('temperature', node)
    return {
        'sensor_info': sensor_info,
        'sensor_value': sensor_value
    }


@app.route('/humidity/<node>', methods=["GET"])
def humidity(node):
    sensor_info, sensor_value = scrape('humidity', node)
    return {
        'sensor_info': sensor_info,
        'sensor_value': sensor_value
    }


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)
