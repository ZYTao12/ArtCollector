from django.urls import include, path
from . import views

app_name = 'api'
urlpatterns = [
    path('artwork/', views.ArtworkAPIView.as_view()),
    path('artwork/<uuid:pk>/change/', views.ArtworkChangeAPIView.as_view()),
    path('artwork/<uuid:pk>/process/', views.AzureAPIView.as_view()),
    path('folder/', views.FolderAPIView.as_view()),
    path('folder/<uuid:folder_id>/artwork/', views.FolderArtworkAPIView.as_view()),
    path('artwork/<uuid:pk>/', views.ArtworkDeleteAPIView.as_view()),
    path('folder/<uuid:pk>/', views.FolderDeleteAPIView.as_view()),
]
