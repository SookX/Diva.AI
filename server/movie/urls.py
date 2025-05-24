from django.contrib import admin
from django.urls import path, include
from .views import search_movie
urlpatterns = [
    path("save/", search_movie, name='save')
]