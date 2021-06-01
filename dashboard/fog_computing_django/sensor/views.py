from django.http import Http404
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


class SensorsDetail(APIView):
    def get_object(self, category_slug, sensor_slug):
        try:
            return Sensor.objects.filter(category__slug=category_slug).get(slug=sensor_slug)
        except Sensor.DoesNotExist:
            raise Http404
    def get(self, request, category_slug,sensor_slug, format=None):
        sensor = self.get_object(category_slug, sensor_slug)
        serializer = SensorSerializer(sensor)
        return Response(serializer.data)