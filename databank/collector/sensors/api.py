from flask import Blueprint

from .collect_functions import *

sensors_bp = Blueprint('sensors_bp', __name__)

@sensors_bp.route('/temperature', methods = ["GET"])
def temperature():
    return str(data_average(temperature_value))

@sensors_bp.route('/humidity', methods = ["GET"])
def humidity():
    return str(data_average(humidity_value))

@sensors_bp.route('/pressure', methods = ["GET"])
def pressure():
    return "Hello 3!"

@sensors_bp.route('/gas', methods = ["GET"])
def gas():
    return "Hello 4!"

@sensors_bp.route('/', methods = ["GET"])
def greeting():
    return "Hello Cloud !"