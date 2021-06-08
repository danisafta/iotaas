from sqlalchemy import Column, String, Integer, DateTime, Numeric
from ..base import Base

class Humidity(Base):
    __tablename__ = 'humidity'
    
    id=Column(Integer, primary_key=True)
    node_name=Column('node_name', String(32))
    sensor_info=Column('sensor_info', String(64))
    date=Column('date', DateTime)
    value=Column('value', Numeric)

    def __init__(self, node_name, sensor_info, date, value):
        self.node_name = node_name
        self.sensor_info = sensor_info
        self.date = date
        self.value = value