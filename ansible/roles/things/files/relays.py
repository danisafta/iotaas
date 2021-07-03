from flask_cors import CORS
from flask import Flask, jsonify, request
import RPi.GPIO as GPIO
import socket
import requests
from requests.adapters import HTTPAdapter
from requests.packages.urllib3.util.retry import Retry


relays_map = {}
URL = "http://k8spi.go.ro:8081/event"
node_name = socket.gethostname()
node_name = node_name.upper()


session = requests.Session()
retry = Retry(connect=3, backoff_factor=0.5)
adapter = HTTPAdapter(max_retries=retry)
session.mount('http://', adapter)

GPIO.setmode(GPIO.BCM)


def set_pin_out(pin):
    GPIO.setup(pin, GPIO.OUT)


def clenaup():
    GPIO.cleanup()


def on(pin):
    pin = int(pin)
    msg = "Received command on for pin %s" % pin
    data = {
        "node_name": node_name,
        "value": pin,
        "event_info": msg,
        "sensor": "Relay"
    }

    print("[LOG] %s" % msg)
    response = session.post(url=URL, json=data)
    print(response.status_code)
    print(response.content)
    try:
        GPIO.output(pin, GPIO.HIGH)
        pin = str(pin)
        relays_map[pin] = True
    except:
        print("Error when trying to turn off")


def off(pin):
    pin = int(pin)
    msg = "Received command off for pin %s" % pin
    data = {
        "node_name": node_name,
        "value": pin,
        "event_info": msg,
        "sensor": "Relay"
    }

    print("[LOG] %s" % msg)
    response = session.post(url=URL, json=data)
    print(response.status_code)
    print(response.content)
    try:
        GPIO.output(pin, GPIO.LOW)
        pin = str(pin)
        relays_map[pin] = False
    except:
        print("Error when trying to turn off")


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
    if state == "on":
        if id not in relays_map.keys():
            set_pin_out(id)
        on(id)
    elif state == "off":
        off(id)
        clenaup()
    return "State changed"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5010)
    GPIO.cleanup()
