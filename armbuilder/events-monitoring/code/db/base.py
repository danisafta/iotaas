from flask.wrappers import Response
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from .conf import POSTGRES_URL

engine = create_engine(POSTGRES_URL)
Session = sessionmaker(bind=engine)

Base = declarative_base()
