from .models import Artwork, Folder
from rest_framework import status, views
from drf_spectacular.utils import extend_schema
from django_filters import rest_framework as filters
import requests
from django.http import HttpResponse
from django.http import HttpRequest
from rest_framework.response import Response
from rest_framework.generics import get_object_or_404
from .serializers import ArtworkSerializer, FolderSerializer
#from rest_framework.authentication import get_authorization_header
#from rest_framework.permissions import BasePermission
from api.azure_tools import labelreader, upload_to_azure
import json
from django.db.models import Q
from django.db import transaction

""" class IsDummyAuthenticated(BasePermission):
    keyword = 'Bearer'

    def has_permission(self, request, view):
        auth = get_authorization_header(request).split()

        if not auth or auth[0].lower() != self.keyword.lower().encode():
            return False

        if len(auth) != 2:
            return False

        jwt_token = auth[1]
        if jwt_token == b'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoyMDE4MTU1MTg1LCJpYXQiOjE3MDI3OTUxODUsImp0aSI6ImQxNTRhZjM5OWE1MjQ1YTI5ZjBhMWIyNTRmNzY2MjY5IiwidXNlcl9pZCI6M30.3jEpMTXZJe2MdLKNMOzOlrS16Mvw5VnShKyaC777vuo':
            return True
        else :
            return False """

class ArtworkFilter(filters.FilterSet):
    
    # start = filters.DateTimeFilter(field_name='start_at', lookup_expr='gte')
    # end = filters.DateTimeFilter(field_name='start_at', lookup_expr='lte')
    # gender = filters.NumberFilter(field_name='gender')
    # min_size = filters.NumberFilter(field_name='shoes_size', lookup_expr='gte')
    # max_size = filters.NumberFilter(field_name='shoes_size', lookup_expr='lte')
    id = filters.CharFilter(field_name='id', lookup_expr='icontains')

    order = filters.OrderingFilter(
        fields=(
            ('created', 'updated'),
        ),
    )

    class Meta:
        model = Artwork
        exclude = ['id',]

class ArtworkAPIView(views.APIView):
    #permission_classes = (IsDummyAuthenticated,)

    @extend_schema(responses={200: ArtworkSerializer})
    def get(self, request, *args, **kwargs):
        filterset = ArtworkFilter(request.query_params, queryset=Artwork.objects.all())
        serializer = ArtworkSerializer(instance=filterset.qs.all(), many=True)
        return Response(serializer.data)
    
    @extend_schema(request=ArtworkSerializer, responses={201: ArtworkSerializer})
    def post(self, request, *args, **kwargs):
        print("POST request data:", request.data) 
        serializer = ArtworkSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data, status.HTTP_201_CREATED)
""" 
    @extend_schema(request=ArtworkSerializer, responses={200: ArtworkSerializer})
    def put(self, request, *args, **kwargs):
        session = get_object_or_404(Artwork, pk=Artwork.id)
        serializer = ArtworkSerializer(session, data=request.data, partial=True)
        if serializer.is_valid(raise_exception=True):
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST) """

class ArtworkChangeAPIView(views.APIView):
    @extend_schema(request=ArtworkSerializer, responses={200: ArtworkSerializer})
    def get(self, request, *args, **kwargs):
        return Response(status=status.HTTP_200_OK)

    @extend_schema(request=ArtworkSerializer, responses={200: ArtworkSerializer})
    def put(self, request, *args, **kwargs):
        pk = self.kwargs.get('pk')
        artwork = get_object_or_404(Artwork, pk=pk)
        serializer = ArtworkSerializer(artwork, data=request.data, partial=True)
        if serializer.is_valid(raise_exception=True):
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class AzureAPIView(views.APIView):

    def get(self, request, pk):
        # Get the artwork object
        artwork = get_object_or_404(Artwork, pk=pk)
        # Upload the image to Azure
        container_name = "testing-data"  # You might want to store this in settings
        blob_url = upload_to_azure.upload_artwork_label(artwork.label_path, container_name, str(artwork.id))

        # Analyze the label using the blob URL
        json_result = labelreader.analyze_label(blob_url, str(artwork.id))
        print("json_result: ", json_result)
        return Response(json_result, status=status.HTTP_200_OK)
    
    # def put(self, request, *args, **kwargs):
    #     return Response(status=status.HTTP_200_OK)
    
class FolderAPIView(views.APIView):
    @extend_schema(responses={200: FolderSerializer(many=True)})
    def get(self, request, *args, **kwargs):
        folders = Folder.objects.all()
        serializer = FolderSerializer(folders, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
    
    @extend_schema(request=FolderSerializer, responses={200: FolderSerializer})
    def post(self, request, *args, **kwargs):
        serializer = FolderSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    
class FolderArtworkAPIView(views.APIView):
    @extend_schema(responses={200: ArtworkSerializer(many=True)})
    def get(self, request, folder_id, *args, **kwargs):
        try:
            folder = Folder.objects.get(folderId=folder_id)
            artworks = Artwork.objects.filter(folder=folder)
            serializer = ArtworkSerializer(artworks, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Folder.DoesNotExist:
            return Response({"error": "Folder not found"}, status=status.HTTP_404_NOT_FOUND)
        
class ArtworkDeleteAPIView(views.APIView):
    @extend_schema(responses={200: ArtworkSerializer})
    def get(self, request, *args, **kwargs):
        pk = self.kwargs.get('pk')
        artwork = get_object_or_404(Artwork, pk=pk)
        serializer = ArtworkSerializer(artwork)
        return Response(serializer.data, status=status.HTTP_200_OK)

    @extend_schema(responses={204: None})
    def delete(self, request, *args, **kwargs):
        pk = self.kwargs.get('pk')
        artwork = get_object_or_404(Artwork, pk=pk)
        artwork.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
    
class FolderDeleteAPIView(views.APIView):
    @extend_schema(responses={200: FolderSerializer})
    def get(self, request, *args, **kwargs):
        pk = self.kwargs.get('pk')
        folder = get_object_or_404(Folder, pk=pk)
        serializer = FolderSerializer(folder)
        return Response(serializer.data, status=status.HTTP_200_OK)
    
    @extend_schema(responses={204: None})
    def delete(self, request, *args, **kwargs):
        pk = self.kwargs.get('pk')
        folder = get_object_or_404(Folder, pk=pk)
        
        with transaction.atomic():
            # Delete all artworks associated with this folder
            Artwork.objects.filter(folder=folder).delete()
            # Delete the folder
            folder.delete()
        
        return Response(status=status.HTTP_204_NO_CONTENT)