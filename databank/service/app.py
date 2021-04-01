from flask import Flask

from sensors.sensors import sensors_bp
from api.api import api_bp


app = Flask(__name__)

app.register_blueprint(sensors_bp, url_prefix='/sensors')
app.register_blueprint(api_bp)
