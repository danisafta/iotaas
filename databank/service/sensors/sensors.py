from flask import Blueprint, render_template, jsonify
import os,sys,inspect

currentdir = os.path.dirname(os.path.abspath(
    inspect.getfile(inspect.currentframe())))
parentdir = os.path.dirname(currentdir)
databank_dir = os.path.dirname(parentdir)
sys.path.insert(0,databank_dir) 

from db.models.gas import Gas
from db.models.humidity import Humidity
from db.models.temperature import Temperature
from db.models.pressure import Pressure
from db.base import Session


session = Session()

sensors_bp = Blueprint('sensors_bp', __name__)

@sensors_bp.route('/temperature')
def temperature():
    return "Temp"

@sensors_bp.route('/gas')
def gas():
    return "Gas"

@sensors_bp.route('/humidity')
def humidity():
    return "Hum"

@sensors_bp.route('/pressure', methods = ["POST"])
def pressure():
    return "Pres"
