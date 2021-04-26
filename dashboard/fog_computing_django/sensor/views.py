from django.shortcuts import render

from rest_framework.views import APIView
from rest_framework.response import Response

from .models import Sensor
from .serializers import SensorSerializer

class SensorsList(APIView):
    def get(self, request, format=None):
        sensors = Sensor.objects.all()[0:4]
        serializer = SensorSerializer(sensors, many=True)
        return Response(serializer.data)
        
