# from django.test import TestCase
from django.db.models import Q
from django.http import Http404
from django.shortcuts import render

from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.decorators import api_view
import requests

@api_view(['GET'])
def index(request, name, node):
    
    url = 'http://k8spi.go.ro:8080/' + str(name) + '/' + node
    
    # print(url)
    response = requests.get(url)
    # print(query.content)
    # measurement = query.json().get('sensor_value')
    return Response(response.json())