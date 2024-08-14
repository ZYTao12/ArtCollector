from django.urls import include, path
from . import views

app_name = 'api'
urlpatterns = [
    path('artwork/', views.ArtworkAPIView.as_view()),
    path('artwork/<uuid:pk>/change/', views.ArtworkChangeAPIView.as_view()),
    path('artwork/<uuid:pk>/process/', views.AzureAPIView.as_view()),
]
