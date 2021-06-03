from flask import Flask
from db.base import scrape

app = Flask(__name__)

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
