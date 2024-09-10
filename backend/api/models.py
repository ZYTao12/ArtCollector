from django.db import models
from django.contrib.auth.models import AbstractUser
from django.contrib.auth.validators import UnicodeUsernameValidator
import uuid

class Folder(models.Model):

    folderId = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    displayName = models.CharField(max_length=200)
    folderDescription = models.TextField(blank=True, null=True)
    created = models.DateTimeField(auto_now_add=True)
    updated = models.DateTimeField(auto_now=True)
    # parent_folder = models.ForeignKey('self', on_delete=models.CASCADE, null=True, blank=True, related_name='child_folders')

    def __str__(self):
        return self.name
    
class Artwork(models.Model):

    # A UUID field that automatically generates a unique identifier on creation
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)

    label_path = models.CharField(max_length=500, null=True)
    picture_path = models.CharField(max_length=500, null=True)

    folder = models.ForeignKey(Folder, on_delete=models.CASCADE, null=True, blank=True, related_name='artworks')

    name = models.CharField(max_length=200, null=True)
    date_of_creation = models.CharField(max_length=50, null=True)
    medium = models.CharField(max_length=100, null=True)
    description = models.TextField(null=True) # ocr processed text
    author = models.CharField(max_length=200, null=True)

    # characteristics to be trained
    # dimensions = models.CharField(max_length=100)
    # style = models.CharField(max_length=100)
    # exhibition = models.CharField(max_length=200)
    # memo = models.TextField()
    # picture = models.TextField()  # path to the artwork pic saved on azure storage
    
    # auto-genrated fields
    created = models.DateTimeField(auto_now_add=True)
    updated = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-created']  # Orders by creation date, newest first
        verbose_name = "Artwork"
        verbose_name_plural = "Artworks"
        db_table = 'artwork_records'
    
class User(AbstractUser):
    username_validator = UnicodeUsernameValidator()

    first_name = models.CharField(max_length=50)
    last_name = models.CharField(max_length=50)
    date_joined = None
    groups = None
    id = models.AutoField(primary_key=True)
    username = models.CharField(max_length=150, unique = False, validators=[username_validator])
    email = models.EmailField(max_length=254, unique=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    USERNAME_FIELD = "id"
    REQUIRED_FIELDS = ["email", "username"]

    class Meta:
        ordering = ["updated_at"]
        db_table = "user"

    def __str__(self):
        return self.username

