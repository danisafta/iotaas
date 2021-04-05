from flask import Blueprint

sensors_bp = Blueprint('sensors_bp', __name__)

@sensors_bp.route('/temperature', methods = ["GET"])
def temperature():
    return "Hello 1!"

@sensors_bp.route('/humidity', methods = ["GET"])
def humidity():
    return "Hello 2!"

@sensors_bp.route('/pressure', methods = ["GET"])
def pressure():
    return "Hello 3!"

@sensors_bp.route('/gas', methods = ["GET"])
def gas():
    return "Hello 4!"

@sensors_bp.route('/', methods = ["GET"])
def greeting():
    return "Hello Cloud !"