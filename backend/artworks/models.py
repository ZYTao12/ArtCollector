from django.db import models
import uuid

class Artwork(models.Model):

    # A UUID field that automatically generates a unique identifier on creation
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    # Text fields for various string inputs with specified characteristics
    info = models.TextField() # path to the pic to be processed by ocr
    description = models.TextField() # ocr processed text
    name = models.CharField(max_length=200)
    author = models.CharField(max_length=200)
    folder = models.UUIDField(default=uuid.uuid4, editable=False)  # folder as UUID
    date_of_creation = models.CharField(max_length=50)
    medium = models.CharField(max_length=100)
    dimensions = models.CharField(max_length=100)
    style = models.CharField(max_length=100)
    exhibition = models.CharField(max_length=200)
    memo = models.TextField()
    picture = models.TextField()  # path to another pic saved on AWS S3
    created = models.DateTimeField(auto_now_add=True)
    updated = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-created']  # Orders by creation date, newest first
        verbose_name = "Artwork"
        verbose_name_plural = "Artworks"
        db_table = 'artwork_records'

class Folder(models.Model):

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=200)
    description = models.TextField(blank=True, null=True)
    created = models.DateTimeField(auto_now_add=True)
    updated = models.DateTimeField(auto_now=True)
    parent_folder = models.ForeignKey('self', on_delete=models.CASCADE, null=True, blank=True, related_name='child_folders')

    def __str__(self):
        return self.name