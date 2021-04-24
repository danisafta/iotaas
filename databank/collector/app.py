from flask import Flask
from flask_json import FlaskJSON

from sensors.api import sensors_bp
from controllers.api import controllers_bp

app = Flask(__name__)
json = FlaskJSON(app)

app.register_blueprint(sensors_bp, url_prefix='/sensors')
app.register_blueprint(controllers_bp, url_prefix='/controllers')

if __name__ == "__main__":
    app.run(debug=True, host = "0.0.0.0")