from datetime import date
from gas import Gas
from humidity import Humidity
from base import Session, engine, Base

Base.metadata.create_all(engine)


session = Session()

gas_sensor1 = ("worker01", "01", date(2021, 3, 10))