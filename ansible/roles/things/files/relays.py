from flask import Flask, jsonify, request
import RPi.GPIO as GPIO
import socket
from flask_cors import CORS


def on(pin):
    try:
        GPIO.output(pin, GPIO.HIGH)
    except:
        print("Error when trying to turn on")


def off(pin):
    try:
        GPIO.output(pin, GPIO.LOW)
    except:
        print("Error when trying to turn off")


URL = "http://k8spi.go.ro:8081/event"
node_name = socket.gethostname()
node_name = node_name.upper()


app = Flask(__name__)
CORS(app)


@app.route('/state/<id>', methods=["GET"])
def get_relay(id):
    try:
        id = int(id)
        pin_state = GPIO.input(id)
        return "State is {} for relay_id = {}".format(pin_state, id)
    except:
        return "State is off for relay_id = {}".format(id)


@app.route('/relay/<relay_id>', methods=["POST"])
def relay(id):
    '''id == gpio pin number'''
    data = request.get_json()
    state = data.get('state')

    # GPIO setup
    GPIO.setmode(GPIO.BCM)
    GPIO.setup(id, GPIO.OUT)

    if state == "on":
        on(id)
    elif state == "off":
        off(id)

    return "State changed"


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5010)
    GPIO.cleanup()
