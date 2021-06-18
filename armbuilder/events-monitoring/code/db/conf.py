import os

# PostgresSQL auth and db
POSTGRES_DB = os.getenv('POSTGRES_DB')
POSTGRES_USER = os.getenv('POSTGRES_USER')
POSTGRES_PW = os.getenv('POSTGRES_PW')
POSTGRES_URL = 'postgresql://' + POSTGRES_USER + ':' + POSTGRES_PW +'@postgres:5432/' + POSTGRES_DB
