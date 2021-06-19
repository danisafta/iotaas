import RPi.GPIO as GPIO
import time
import socket
import requests
from requests.adapters import HTTPAdapter
from requests.packages.urllib3.util.retry import Retry


session = requests.Session()
retry = Retry(connect=3, backoff_factor=0.5)
adapter = HTTPAdapter(max_retries=retry)
session.mount('http://', adapter)

#GPIO SETUP
flame_channel = 21
GPIO.setmode(GPIO.BCM)
GPIO.setup(flame_channel, GPIO.IN)

#GPIO SETUP
sound_channel = 17
GPIO.setmode(GPIO.BCM)
GPIO.setup(sound_channel, GPIO.IN)

URL = "http://k8spi.go.ro:8081/event"
node_name = socket.gethostname()
node_name = node_name.upper()

def flame_callback(flame_channel):
    print(flame_channel)
    print("Flame detected. Reporting data to events-api")
    data = {
        "node_name": node_name,
        "value": 1,
        "event_info": "Flame detected",
        "sensor": "IR Flame Sensor"
    }
    response = session.post(url=URL, json= data)
    print(response.status_code)
    print(response.content)
 
def sound_callback(sound_channel):
    print("Sound detected. Reporting data to events-api")
    data = {
        "node_name": node_name,
        "value": 1,
        "event_info": "Sound detected",
        "sensor": "High Sensitivity Microphone"
    }
    response = session.post(url=URL, json= data)    
    print(response.status_code)
    print(response.content)


GPIO.add_event_detect(flame_channel, GPIO.BOTH, bouncetime=300)  # let us know when the pin goes HIGH or LOW
GPIO.add_event_callback(flame_channel, flame_callback)  # assign function to GPIO PIN, Run function on change


GPIO.add_event_detect(sound_channel, GPIO.BOTH, bouncetime=300)  # let us know when the pin goes HIGH or LOW
GPIO.add_event_callback(sound_channel, sound_callback)  # assign function to GPIO PIN, Run function on change


# infinite loop
while True:
        time.sleep(10)
