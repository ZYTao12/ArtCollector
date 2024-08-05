from django.conf import settings
from django.conf.urls.static import static
from django.contrib import admin
from django.urls import path, include
from django.views.generic import TemplateView
from drf_spectacular.views import SpectacularAPIView, SpectacularSwaggerView

urlpatterns = [
    
    #path('admin/', admin.site.urls),
    path('api/', include('api.urls')),
]

""" if settings.DEBUG:
    import debug_toolbar

    urlpatterns += [
      path("__debug__/", include("debug_toolbar.urls")),
      path('api/schema/', SpectacularAPIView.as_view(), name='schema'),
      path('api/schema/swagger-ui/', SpectacularSwaggerView.as_view(url_name='schema'), name='swagger-ui'),
    ]
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT) """