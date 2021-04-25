FROM python:3.8
LABEL maintainer="saftamailbox@gmail.com"
WORKDIR /app

COPY requirements.txt requirements.txt

RUN pip install -r requirements.txt

COPY code/ .

CMD ["python", "app.py"]