from django.urls import include, path
from . import views

app_name = 'api'
urlpatterns = [
    path('artworks/', views.ArtworkAPIView.as_view()),
    path('artworks/<pk>/change/', views.ArtworkAPIView.as_view()),
]
