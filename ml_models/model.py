import torch
import torch.nn as nn

class Doc2Vec(nn.Module):
    def __init__(self, vocab_size, doc_size, embedding_dim):
        super().__init__()
        self.vocab_size = vocab_size
        self.doc_size = doc_size
        self.embedding_dim = embedding_dim
        self.doc_embed = nn.Embedding(doc_size, embedding_dim)
        self.word_embed = nn.Embedding(vocab_size, embedding_dim)
        self.linear = nn.Linear(embedding_dim, vocab_size)

    def forward(self, doc_ids, context_words):
        doc_vecs = self.doc_embed(doc_ids).unsqueeze(1)  
        word_vecs = self.word_embed(context_words)      

        combined = torch.cat([doc_vecs, word_vecs], dim=1)  
        mean_vec = combined.mean(dim=1)                     

        logits = self.linear(mean_vec)
        return logits