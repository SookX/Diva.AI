import torch
import torch.nn as nn
from torch.utils.data import DataLoader
import logging
from tqdm import tqdm
import time

logging.basicConfig(level=logging.INFO, format='[%(levelname)s] %(message)s')

def train_step(model: nn.Module, train_dataloader: torch.utils.data.DataLoader, epochs: int, loss_fn: nn.Module, optimizer: nn.Module, device = "cpu") -> None:
    """
    Trains a PyTorch model for a specified number of epochs using the provided dataloader, loss function, and optimizer.

    Args:
        model (nn.Module): The neural network model to train.
        train_dataloader (DataLoader): A DataLoader that yields batches of (doc_id, context_words, target).
        epochs (int): Number of training epochs.
        loss_fn (nn.Module): Loss function to optimize (e.g., nn.CrossEntropyLoss).
        optimizer (Optimizer): Optimizer for updating model parameters (e.g., Adam, SGD).
        device (str, optional): Device to train the model on ('cpu' or 'cuda'). Defaults to 'cpu'.

    Returns:
        None
    """
    
    logging.info("Initializing model training...\n")

    for epoch in tqdm(range(epochs)):
        start_time = time.time()
        epoch_loss = 0.0
        for doc_id, context_words, target in train_dataloader:
            doc_id = doc_id.to(device)
            context_words = context_words.to(device)
            target = target.to(device)

            logits = model(doc_id, context_words)
            loss = loss_fn(logits, target)

            optimizer.zero_grad()
            loss.backward()
            optimizer.step()

            epoch_loss += loss.item()
        avg_loss = epoch_loss / len(train_dataloader)
        duration = time.time() - start_time

        logging.info(f"Epoch [{epoch}/{epochs}] | Loss: {avg_loss:.4f} | Time: {duration:.2f}s")