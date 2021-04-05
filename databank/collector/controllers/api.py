from flask import Blueprint

controllers_bp = Blueprint('controllers_bp', __name__)

@controllers_bp.route('/temperature', methods = ["GET"])
def temperature():
    return "Hello 1!"

@controllers_bp.route('/humidity', methods = ["GET"])
def humidity():
    return "Hello 2!"

@controllers_bp.route('/pressure', methods = ["GET"])
def pressure():
    return "Hello 3!"

@controllers_bp.route('/gas', methods = ["GET"])
def gas():
    return "Hello 4!"

@controllers_bp.route('/', methods = ["GET"])
def greeting():
    return "Hello Cloud !"