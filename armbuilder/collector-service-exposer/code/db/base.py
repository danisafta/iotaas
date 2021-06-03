from flask.wrappers import Response
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import requests
from .conf import POSTGRES_URL, all_nodes

engine = create_engine(POSTGRES_URL)
Session = sessionmaker(bind=engine)

Base = declarative_base()


def check_response(response: Response) -> bool:
    ''' Checks if the response is valid'''
    if response.status_code != 200:
        return False

    rjson = response.json()
    if rjson['rmsg'] != 'OK':
        return False

    return True


def scrape(sensor: str, node_name: str) -> (str, str):
    ''' 
        Scrapes the sensor on all of the nodes
        in the cluster and inserts the value in the db
    '''
    node_ip = ""
    sensor_info = ""
    sensor_value = ""

    for node in all_nodes:
        if node_name == node['name']:
            node_ip = node['ip']

    try:
        print("[LOG] Scrapping " + sensor + " from " + node_name)
        URL = 'http://' + node_ip + ':5000/sensors/' + sensor
        response = requests.get(URL)
        rjson = response.json()
        sensor_info = rjson['sensor']
        sensor_value = rjson['value']
    except Exception:
        print("[EXCEPT] Exception when scrapping " +
              sensor + " from " + node_name)

    return sensor_info, sensor_value
