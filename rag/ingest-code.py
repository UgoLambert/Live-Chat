import os
import warnings

import dotenv
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.document_loaders import (
    DirectoryLoader,
    UnstructuredMarkdownLoader,
)
from langchain_community.document_loaders.generic import GenericLoader
from langchain_community.document_loaders.parsers import LanguageParser
from langchain_community.embeddings import HuggingFaceEmbeddings
from langchain_community.vectorstores import Chroma
from langchain_openai import OpenAIEmbeddings

from helpers import load_env

import chardet
from pathlib import Path

warnings.simplefilter("ignore")

attrs = load_env()

chunk_size = 3000
chunk_overlap = 400


def create_vector_database():
    """
    Creates a vector database using document loaders and embeddings.

    This function loads data from markdown, text and code files in the codebase directory,
    splits the loaded documents into chunks, transforms them into embeddings using HuggingFaceEmbeddings,
    and finally persists the embeddings into a Chroma vector database.

    """
    chunked_documents = []
    chunked_documents.extend(chunk_code())
    chunked_documents.extend(chunk_docs())

    embeddings = HuggingFaceEmbeddings(
        model_name="jinaai/jina-embeddings-v2-base-code",
        model_kwargs={"trust_remote_code": True},
    )

    vector_database = Chroma.from_documents(
        documents=chunked_documents,
        embedding=embeddings,
        persist_directory=attrs["VECTOR_DB_PATH"],
    )

    vector_database.persist()


def chunk_code():
    parser = LanguageParser(language=attrs["CODEBASE_LANGUAGE"])
    loader = GenericLoader.from_filesystem(
        attrs["CODEBASE_PATH"],
        glob="**/*",
        suffixes=attrs["CODE_SUFFIXES"],
        parser=parser
    )
    loaded_documents = loader.load()
    splitter = RecursiveCharacterTextSplitter.from_language(
        language=attrs["CODEBASE_LANGUAGE"],
        chunk_size=chunk_size,
        chunk_overlap=chunk_overlap,
    )
    chunked_documents = splitter.split_documents(loaded_documents)
    return chunked_documents


def chunk_docs():
    loader = DirectoryLoader(
        attrs["CODEBASE_PATH"], glob="**/*.md", loader_cls=UnstructuredMarkdownLoader
    )
    loaded_documents = loader.load()
    splitter = RecursiveCharacterTextSplitter(
        chunk_size=chunk_size, chunk_overlap=chunk_overlap
    )
    chunked_documents = splitter.split_documents(loaded_documents)
    return chunked_documents

def convert_to_utf8(file_path):
    with open(file_path, 'rb') as file:
        raw_data = file.read()
        detected_encoding = chardet.detect(raw_data)['encoding']

    with open(file_path, 'r', encoding=detected_encoding, errors='ignore') as file:
        file_content = file.read()

    with open(file_path, 'w', encoding='utf-8') as file:
        file.write(file_content)

    print(f"Fichier {file_path} converti en UTF-8.")

def convert_files_in_directory_to_utf8(directory, file_suffixes):
    for file_path in Path(directory).rglob('*'):
        if file_path.suffix in file_suffixes:
            try:
                convert_to_utf8(file_path)
            except Exception as e:
                print(f"Erreur lors de la conversion de {file_path}: {e}")


if __name__ == "__main__":
    convert_files_in_directory_to_utf8(attrs["CODEBASE_PATH"], attrs["CODE_SUFFIXES"])
    print("\n### Ingestion ###\n")
    create_vector_database()
    print("\n### Digéré  ###\n")
