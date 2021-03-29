from sqlalchemy import Column, String, Integer, Date
from base import Base

class Temperature(Base):
    __tablename__ = 'temperature'
    
    id=Column(Integer, primary_key=True)
    node_name=Column('node_name', String(32))
    sensor_id=Column('sensor_id', Integer)
    date=Column('date', Date)
    value=Column('quantity', Numeric)

    def __init__(self, node_name, sensor_id, date, value):
        self.node_name = node_name
        self.sensor_id = sensor_id
        self.date = date
        self.value = value