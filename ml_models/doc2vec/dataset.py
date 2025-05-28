import torch
from torch.utils.data import Dataset

class MovieDataset(Dataset):
    def __init__(self, tokenized_docs, word2idx, window_size = 2):
        self.data = []
        self.word2idx = word2idx
        self.window_size = window_size
        for doc_id, doc in enumerate(tokenized_docs):
            idxs = [word2idx[word] for word in doc]
            for i in range(window_size, len(idxs) - 2):
                context = idxs[i - window_size: i] + idxs[i + 1: i +1+window_size]
                target = idxs[i]
                self.data.append((doc_id, context, target))
    def __len__(self):
        return len(self.data)
    
    def __getitem__(self, index):
        doc_id, context, target = self.data[index]
        return torch.tensor(doc_id), torch.tensor(context), torch.tensor(target)
