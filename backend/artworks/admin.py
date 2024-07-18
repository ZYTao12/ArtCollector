from django.contrib import admin
from .models import Artwork, Folder

class ArtworkModelAdmin(admin.ModelAdmin):
    list_display = ('id', 'info', 'description', 'name', 'author', 'folder', 'date_of_creation', 'medium', 'dimensions', 'style', 'exhibition', 'memo', 'picture', 'created', 'updated')
    ordering = ('-created',)
    readonly_fields = ('id', 'created', 'updated')

admin.site.register(Artwork, ArtworkModelAdmin)
