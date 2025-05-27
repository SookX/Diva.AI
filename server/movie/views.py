import requests
from rest_framework.decorators import api_view
from rest_framework.response import Response
import os

@api_view(['GET'])
def search_movie(request):
    page = request.query_params.get('page', 1)

    url = "https://api.themoviedb.org/3/discover/movie"
    params = {
        "api_key": os.getenv("API_KEY"),
        "page": page
    }

    response = requests.get(url, params=params)
    if response.status_code != 200:
        return Response({"error": "TMDb request failed"}, status=response.status_code)

    return Response(response.json())