from utils import load_dataset, column_to_list, preprocess_documents, read_config, save_model
from dataset import MovieDataset
from model import Doc2Vec
from train import train_step

import torch
import torch.nn as nn
from torch.utils.data import DataLoader

if __name__ == "__main__":
    
    dataset = load_dataset("../data/dataset.csv")
    config_values = read_config()

    docs = column_to_list(dataset["description"])
    tokenized_docs, vocab = preprocess_documents(docs)
    
    device = "cuda" if torch.cuda.is_available() else "cpu"
    print(f"Using device: {device}")

    model_dataset = MovieDataset(tokenized_docs, vocab)
    train_dataloader = DataLoader(model_dataset, config_values['batch_size'], shuffle = True)
    
    model = Doc2Vec(len(vocab), len(docs), config_values['embedding_dim']).to(device)
    
    loss_fn = nn.CrossEntropyLoss()
    optimizer = torch.optim.Adam(model.parameters(), lr=config_values['learning_rate'])
    train_step(model, train_dataloader, config_values['epochs'], loss_fn, optimizer, device)
    save_model(model, "doc2vec-small.pth")
