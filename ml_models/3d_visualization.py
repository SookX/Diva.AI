import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from matplotlib import animation
from sklearn.decomposition import PCA
from ast import literal_eval
from mpl_toolkits.mplot3d import Axes3D
from sklearn.metrics.pairwise import cosine_similarity

df = pd.read_csv("movie2vec.csv")
df['vector'] = df['vector'].apply(literal_eval)
vectors = np.array(df['vector'].tolist())

pca = PCA(n_components=3)
reduced_vectors = pca.fit_transform(vectors)

similarity_matrix = cosine_similarity(vectors)
np.fill_diagonal(similarity_matrix, -1)
closest_pair = np.unravel_index(np.argmax(similarity_matrix), similarity_matrix.shape)
movie_1 = df.iloc[closest_pair[0]]
movie_2 = df.iloc[closest_pair[1]]

print("Most similar movies:")
print(f"1. {movie_1['title']}")
print(f"2. {movie_2['title']}")
print(f"Cosine similarity: {similarity_matrix[closest_pair]:.4f}")

norm = plt.Normalize(reduced_vectors[:, 2].min(), reduced_vectors[:, 2].max())
colors = plt.cm.hot(norm(reduced_vectors[:, 2])) 

fig = plt.figure(figsize=(10, 8))
ax = fig.add_subplot(111, projection='3d')

sc = ax.scatter(reduced_vectors[:, 0], reduced_vectors[:, 1], reduced_vectors[:, 2], 
                c=colors, s=40)

for i in range(0, len(df), max(len(df) // 50, 1)):
    ax.text(reduced_vectors[i, 0], reduced_vectors[i, 1], reduced_vectors[i, 2], 
            df['title'][i], fontsize=8)

ax.set_title("3D PCA of Movie Vectors")
ax.set_xlabel("PC1")
ax.set_ylabel("PC2")
ax.set_zlabel("PC3")

def rotate(angle):
    ax.view_init(30, angle)

ani = animation.FuncAnimation(fig, rotate, frames=np.arange(0, 360, 2), interval=100)


ani.save("movie_vectors_rotation.mp4", writer='ffmpeg', dpi=200)

plt.show()
