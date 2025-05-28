import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.preprocessing import MultiLabelBinarizer
from collections import Counter
import configparser
import torch


def load_dataset(filename: str) -> pd.DataFrame:
    """
    Load a dataset from a CSV file using pandas.

    Args:
        filename (str): Path to the CSV file.

    Returns:
        pd.DataFrame: DataFrame containing the loaded dataset.
    """
    return pd.read_csv(filename)


def one_hot_encode_genres(df: pd.DataFrame) -> tuple[pd.DataFrame, list[str]]:
    """
    One-hot encode the 'genres' column of a DataFrame.

    Assumes the 'genres' column contains comma-separated string labels.
    Adds new binary columns for each unique genre.

    Args:
        df (pd.DataFrame): Input DataFrame with a 'genres' column.

    Returns:
        tuple:
            - pd.DataFrame: DataFrame with added one-hot encoded genre columns.
            - list[str]: List of genre class labels used in encoding.
    """
    df['genres_list'] = df['genres'].apply(lambda x: [genre.strip() for genre in x.split(',')])

    mlb = MultiLabelBinarizer()
    genre_encoded = mlb.fit_transform(df['genres_list'])
    genre_columns = mlb.classes_

    genre_df = pd.DataFrame(genre_encoded, columns=genre_columns, index=df.index)

    df = pd.concat([df, genre_df], axis=1)

    return df, list(genre_columns)


def column_to_list(col: pd.Series) -> list:
    """
    Convert a pandas Series column into a list.

    Args:
        col (pd.Series): Input column to convert.

    Returns:
        list: List of column values.
    """
    return col.values.tolist()


def preprocess_documents(docs: list[str]) -> tuple[list[list[str]], dict[str, int]]:
    """
    Tokenize and preprocess a list of documents.

    Converts documents to lowercase, splits into words, and builds a vocabulary dictionary
    mapping each word to a unique integer index. Includes a '<PAD>' token.

    Args:
        docs (list[str]): List of text documents.

    Returns:
        tuple:
            - list[list[str]]: Tokenized list of documents.
            - dict[str, int]: Vocabulary dictionary {word: index}.
    """
    tokenized_docs = [str(doc).lower().split() for doc in docs]
    word_counts = Counter(word for doc in tokenized_docs for word in doc)
    vocab = {word: idx for idx, (word, _) in enumerate(word_counts.items(), start=1)}
    vocab['<PAD>'] = 0
    return tokenized_docs, vocab


def create_config() -> None:
    """
    Create a configuration file with default hyperparameters.

    Creates a file named 'config.ini' containing:
    - batch_size
    - epochs
    - embedding_dim
    """
    config = configparser.ConfigParser()
    config['hyperparameters'] = {
        'batch_size': 64,
        'epochs': 200,
        'embedding_dim': 256
    }
    with open('config.ini', 'w') as configfile:
        config.write(configfile)


def read_config() -> dict[str, int]:
    """
    Read hyperparameters from the 'config.ini' file.

    Returns:
        dict[str, int]: Dictionary containing batch_size, epochs, and embedding_dim.
    """
    config = configparser.ConfigParser()
    config.read('config.ini')

    config_values = {
        'batch_size': int(config.get('hyperparameters', 'batch_size')),
        'epochs': int(config.get('hyperparameters', 'epochs')),
        'embedding_dim': int(config.get('hyperparameters', 'embedding_dim')),
        'learning_rate': float(config.get('hyperparameters', 'learning_rate'))
    }
    return config_values

def save_model(model: torch.nn.Module, model_name: str) -> None:
    checkpoint = {
        'model_state_dict': model.state_dict(),
        'vocab_size': model.vocab_size,
        'doc_size': model.doc_size,
        'embedding_dim': model.embedding_dim
    }

    torch.save(checkpoint, model_name)

def load_model(model_name: str) -> None:
    return torch.load(model_name)

if __name__ == "__main__":
    create_config()
