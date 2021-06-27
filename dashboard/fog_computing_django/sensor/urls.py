from django.urls import path, include

from .views import SensorsList

from sensor import views
from sensor import tests

urlpatterns= [
    path('sensors-list/', views.SensorsList.as_view()),
    path('sensors/search/', views.search),
    path('sensors/<slug:category_slug>/<slug:sensor_slug>/', views.SensorsDetail.as_view()),
    path('sensors/<slug:category_slug>/', views.CategoryDetail.as_view()),
    path('index/<name>/<node>/', tests.index),
    path('tabledata/<name>/stored/<nr>', tests.tabledata),
]