from django.urls import path
from .views import search_movie

urlpatterns = [
    path("save/", search_movie, name='save')
]