FROM python:3.8
LABEL maintainer="saftamailbox@gmail.com"
WORKDIR /app

COPY requirements.txt requirements.txt

RUN pip install -r requirements.txt

ENV MASTER1=192.168.100.50
ENV WORKER1=192.168.100.52
ENV WORKER2=192.168.100.37
ENV POSTGRES_USER=postgresadmin
ENV POSTGRES_DB=postgresdb
ENV POSTGRES_PW=l1centa

COPY code/ .

CMD ["python", "css.py"]