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

        # offset = self.request.query_params.get("offset", None)
        # if offset:
        #   start_idx = int(offset)

        # limit = self.request.query_params.get("limit", None)
        # if limit:
        #   end_idx = start_idx + int(limit)

        serializer = ArtworkSerializer(instance=filterset.qs.all(), many=True)
        return Response(serializer.data)
    
    @extend_schema(request=ArtworkSerializer, responses={201: ArtworkSerializer})
    def post(self, request, *args, **kwargs):
        serializer = ArtworkSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data, status.HTTP_201_CREATED)

    @extend_schema(request=ArtworkSerializer, responses={200: ArtworkSerializer})
    def put(self, request, pk, *args, **kwargs):
        session = get_object_or_404(Artwork, pk=pk)
        serializer = ArtworkSerializer(session, data=request.data, partial=True)
        if serializer.is_valid(raise_exception=True):
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)