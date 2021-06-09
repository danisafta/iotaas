from django.db.models import Q
from django.http import Http404
from django.shortcuts import render

from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.decorators import api_view

from .models import Sensor, Category
from .serializers import SensorSerializer, CategorySerializer

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

class CategoryDetail(APIView):
    def get_object(self, category_slug):
        try:
            return Category.objects.get(slug=category_slug)
        except Sensor.DoesNotExist:
            raise Http404

    def get(self, request, category_slug, format=None):
        category = self.get_object(category_slug)
        serializer = CategorySerializer(category)
        return Response(serializer.data)
    
@api_view(['POST'])
def search(request):
    query = request.data.get('query', '')

    if query:
        sensors = Sensor.objects.filter(Q(name__icontains=query) | Q(description__icontains=query))
        serializer = SensorSerializer(sensors, many=True)
        return Response(serializer.data)
    else:
        return Response({"sensors": []})