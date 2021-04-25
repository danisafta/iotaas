import time
import requests
import datetime

from db.models.gas import Gas
from db.models.humidity import Humidity
from db.models.pressure import Pressure
from db.models.temperature import Temperature
from db.base import Base, Session, engine
from db.conf import CLUSTER,all_nodes

Base.metadata.create_all(engine)

session = Session()
enbled_sensors = ['temperature','humidity']


def insert(payload: dict, node_name: str, sensor: str) -> bool:
    ''' Inserts the data collected from the sensor in the db '''
    sensor_info = payload['sensor']
    sensor_value = payload['value']
    date = datetime.datetime.now()

    if sensor == "temperature":
        data = Temperature(node_name, sensor_info, date, sensor_value)
        session.add(data)

    if sensor == 'humidity':
        data = Humidity(node_name, sensor_info, date, sensor_value)
        session.add(data)


def check_response(response) -> bool:
    ''' Checks if the response is valid'''
    if response.status_code != 200:
        return False

    rjson = response.json()
    if rjson['rmsg'] != 'OK':
        return False

    return True


def scrape(sensor: str) -> None:
    ''' 
        Scrapes the sensor on all of the nodes
        in the cluster and inserts the value in the db
    '''
    
    for node in all_nodes:
        node_ip = node['ip']
        node_name = node['name']
        print("[LOG] Scrapping " + sensor + " from " + node_name)
        URL = 'http://' + node_ip + ':5000/sensors/' + sensor
        response = requests.get(URL)

        # Valid response, insert it
        if check_response(response):
            insert(response.json(), node_name, sensor)


for on_sensor in enbled_sensors:
    scrape(on_sensor)

session.commit()
session.close()
