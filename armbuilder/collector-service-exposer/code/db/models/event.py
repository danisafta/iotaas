from sqlalchemy import Column, String, Integer,  Boolean
from sqlalchemy.sql.sqltypes import DateTime
from ..base import Base

class Event(Base):
    __tablename__ = 'events'
    
    id=Column(Integer, primary_key=True)
    node_name =Column('node_name', String(32))
    sensor =Column('sensor', String(32))
    date=Column('date', DateTime)
    value=Column('value', Boolean)
    event_info=Column('info', String(256))
    

    def __init__(self, node_name, sensor, date, value, event_info):
        self.node_name = node_name
        self.sensor = sensor
        self.date = date
        self.value = value
        self.event_info = event_info

    def __str__(self):
        return 'Happened on {self.node_name} at {self.date}: {self.event_info}'.format(self=self)
