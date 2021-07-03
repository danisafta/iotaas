FROM python:3.8
LABEL maintainer="saftamailbox@gmail.com"
WORKDIR /app

COPY requirements.txt requirements.txt

RUN pip install -r requirements.txt

ENV POSTGRES_USER=postgresadmin
ENV POSTGRES_DB=postgresdb
ENV POSTGRES_PW=l1centa

COPY code/ .

CMD ["python", "events.py"]