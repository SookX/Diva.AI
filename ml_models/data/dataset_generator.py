import pandas as pd
import requests
from dotenv import load_dotenv
import os
import time

load_dotenv()

API_KEY = os.getenv("API_KEY")

def get_movie_info(title: str, API_KEY: str):
    search_url = "https://api.themoviedb.org/3/search/movie"
    search_params = {
        "api_key": API_KEY,
        "query": title,
        "page": 1
    }
    search_response = requests.get(search_url, params=search_params)
    search_data = search_response.json()

    if search_response.status_code != 200 or not search_data.get("results"):
        return None, None

    movie_id = search_data["results"][0]["id"]

    details_url = f"https://api.themoviedb.org/3/movie/{movie_id}"
    details_params = {"api_key": API_KEY}
    details_response = requests.get(details_url, params=details_params)
    details_data = details_response.json()

    if details_response.status_code != 200:
        return None, None

    description = details_data.get("overview", "No description available")
    genres = [genre['name'] for genre in details_data.get("genres", [])]

    return description, genres


# Load movie titles
df = pd.read_csv("movie_list.txt", header=None, names=["title"])

counter = 0
start_time = time.time()

descriptions = []
genres_list = []

for title in df['title']:
    desc, genres = get_movie_info(title, API_KEY)
    descriptions.append(desc)
    genres_list.append(", ".join(genres) if genres else None)

    counter += 1
    elapsed = time.time() - start_time

    if elapsed > 0:
        rps = counter / elapsed
        print(f"Processed: {counter} titles | Requests per second: {rps:.2f}")

df['description'] = descriptions
df['genres'] = genres_list

df.to_csv("dataset.csv", index=False)
