from django.db import models

class Media(models.Model):
    
    MEDIA_TYPE_CHOICES = [
        ('anime', 'Anime'),
        ('series', 'Series'),
        ('movie', 'Movie'),
    ]

    type = models.CharField(max_length=10, choices=MEDIA_TYPE_CHOICES)
    name = models.CharField(max_length=255)
    vector = models.TextField()
    external_id = models.CharField(max_length=255, unique=True)
    provider = models.CharField(max_length=255)

