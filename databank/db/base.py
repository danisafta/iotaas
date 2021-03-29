from sqlalchemy import create_engine
engine = create_engine('postgresql://postgresadmin:l1centa@localhost:31892/postgresdb')
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
Session = sessionmaker(bind=engine)

Base = declarative_base()

