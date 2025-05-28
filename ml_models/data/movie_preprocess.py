import pandas as pd

# Load movie data
df = pd.read_csv("./plain.csv")

# Remove the date from titles
df["title"] = df["title"].map(lambda x: x.split("(")[0])

df["title"].iloc[:3000].to_csv("movie_list.txt", index=False, header=False)