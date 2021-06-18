from sqlalchemy import Column, String, Integer, Date, Boolean
from sqlalchemy.sql.sqltypes import DateTime
from ..base import Base

class Event(Base):
    __tablename__ = 'events'
    
    id=Column(Integer, primary_key=True)
    node_name =Column('node_name', String(32))
    sensor_id =Column('sensor_id', Integer)
    date=Column('date', DateTime)
    values=Column('values', Boolean)
    event_info=Column('values', String(256))
    

    def __init__(self, node_name, sensor_id, date, value, event_info):
        self.node_name = node_name
        self.sensor_id = sensor_id
        self.date = date
        self.values = value
        self.event_info = event_info

    def __str__(self):
        return 'Happened on {self.node_name} at {self.date}: {self.event_info}'.format(self=self)
