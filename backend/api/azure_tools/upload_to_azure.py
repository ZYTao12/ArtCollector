import os
import configparser
from azure.core.credentials import AzureKeyCredential
from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobServiceClient, BlobClient, ContainerClient

def upload_artwork_label(artwork_label_path, container_name, artwork_uuid):
    account_url = "https://artcollector.blob.core.windows.net/"
    default_credential = DefaultAzureCredential()
    blob_service_client = BlobServiceClient(account_url=account_url, credential=default_credential) 

    blob_client = blob_service_client.get_blob_client(container=container_name, blob=artwork_uuid)

    with open(file=artwork_label_path, mode="rb") as data:
        blob_client.upload_blob(data=data, overwrite=True)

    return blob_client.url