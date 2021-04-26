from django.urls import path, include

from .views import SensorsList

from sensor import views

urlpatterns= [
    path('sensors-list/', views.SensorsList.as_view()),
]