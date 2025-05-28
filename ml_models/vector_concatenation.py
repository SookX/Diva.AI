from doc2vec.utils import load_dataset, one_hot_encode_genres, load_model
from doc2vec.model import Doc2Vec
import torch
from sklearn.preprocessing import normalize
import numpy as np
import pandas as pd

dataset = load_dataset("./data/dataset.csv")
dataset, genres = one_hot_encode_genres(dataset)

checkpoint = torch.load('./doc2vec/doc2vec-small.pth')
vocab_size = checkpoint['vocab_size']
doc_size = checkpoint['doc_size']
embedding_dim = checkpoint['embedding_dim']

model = Doc2Vec(vocab_size, doc_size, embedding_dim)
model.load_state_dict(checkpoint['model_state_dict'])

doc_vectors = model.doc_embed.weight.detach().cpu().numpy()

genre_columns = genres 
genre_vectors = dataset[genre_columns].to_numpy().astype(np.float32) 

combined_vectors = np.hstack((genre_vectors, doc_vectors)) 
titles = dataset["title"].values

vector_strings = [str(vec.tolist()) for vec in combined_vectors]

output_df = pd.DataFrame({
    "title": dataset["title"],
    "vector": vector_strings
})

output_df.to_csv("movie2vec.csv", index=False)



