from django.urls import path, include

from .views import SensorsList

from sensor import views

urlpatterns= [
    path('sensors-list/', views.SensorsList.as_view()),
    path('sensors/search/', views.search),
    path('sensors/<slug:category_slug>/<slug:sensor_slug>/', views.SensorsDetail.as_view()),
    path('sensors/<slug:category_slug>/', views.CategoryDetail.as_view()),
]