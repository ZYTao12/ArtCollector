from .models import Artwork, Folder
from rest_framework import serializers

class ArtworkSerializer(serializers.ModelSerializer):
    label_path = serializers.CharField(required=False)
    folder = serializers.CharField(required=False)
    name = serializers.CharField(required=False, allow_blank=True, allow_null=True)
    date_of_creation = serializers.CharField(required=False, allow_blank=True, allow_null=True)
    medium = serializers.CharField(required=False, allow_blank=True, allow_null=True)
    description = serializers.CharField(required=False, allow_blank=True, allow_null=True)
    author = serializers.CharField(required=False, allow_blank=True, allow_null=True)

    class Meta:
        model = Artwork
        fields = "__all__"

    def create(self, validated_data):
        # Set default values for optional fields if not provided
        validated_data.setdefault('folder', None)
        validated_data.setdefault('name', '')
        validated_data.setdefault('date_of_creation', '')
        validated_data.setdefault('medium', '')
        validated_data.setdefault('description', '')
        validated_data.setdefault('author', '')
        return super().create(validated_data)

class FolderSerializer(serializers.ModelSerializer):
    class Meta:
        model = Folder
        fields = "__all__"