from flask import Flask, jsonify, request
import RPi.GPIO as GPIO
import socket
from flask_cors import CORS
relays_map = {}


def on(pin):
    try:
        GPIO.output(pin, GPIO.HIGH)
        pin = str(pin)
        relays_map[pin] = True
    except:
        print("Error when trying to turn on")


def off(pin):
    try:
        GPIO.output(pin, GPIO.LOW)
        pin = str(pin)
        relays_map[pin] = False
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
        pin_state = relays_map.get(id)
        if pin_state is None:
            pin_state = False
        return "State is {} for relay_id = {}".format(pin_state, id)
    except:
        return "State is off for relay_id = {}".format(id)


@app.route('/relay', methods=["POST"])
def relay():
    '''id == gpio pin number'''
    data = request.get_json()
    state = data.get('state')
    id = data.get('id')
    id = int(id)

    # GPIO setup
    GPIO.setmode(GPIO.BCM)
    GPIO.setup(id, GPIO.OUT)

    if state == "on":
        on(id)
    elif state == "off":
        off(id)

    return "State changed"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5010)
    GPIO.cleanup()
