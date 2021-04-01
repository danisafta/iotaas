from sqlalchemy import Column, String, Integer, Date, Boolean
from ..base import Base

class Gas(Base):
    __tablename__ = 'gas'
    
    id=Column(Integer, primary_key=True)
    node_name=Column('node_name', String(32))
    sensor_id=Column('sensor_id', Integer)
    date=Column('date', Date)
    value=Column('value', Boolean)

    def __init__(self, node_name, sensor_id, date, value):
        self.node_name = node_name
        self.sensor_id = sensor_id
        self.date = date
        self.value = value

    def __str__(self):
        return 'a {self.node_name} car'.format(self=self)
