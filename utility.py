import os
import configparser
from azure.storage.blob import BlobServiceClient
from azure.core.credentials import AzureKeyCredential
from azure.ai.documentintelligence import DocumentIntelligenceClient
from urllib.parse import urlparse
import numpy as np
import cv2
import pillow_heif

def get_blob_service_client():
    config = configparser.ConfigParser()
    config.read('client.ini')
    storage_connection_string = config.get('AzureStorage', 'connection_string')
    return BlobServiceClient.from_connection_string(storage_connection_string)

def download_blob_as_stream(container_name, blob_name):
    blob_client = get_blob_service_client().get_blob_client(container=container_name, blob=blob_name)
    download_stream = blob_client.download_blob()
    return download_stream.readall()

def get_document_ai_client():
    config = configparser.ConfigParser()
    config.read('client.ini')
    api_key = config.get('DocumentAI', 'api_key')
    endpoint = config.get('DocumentAI', 'endpoint')
    return DocumentIntelligenceClient(endpoint=endpoint, credential=AzureKeyCredential(api_key))

def process_document(blob_data):
    client = get_document_ai_client()
    poller = client.begin_analyze_general_documents(blob_data)
    result = poller.result()
    return result.to_dict()

# helper function to convert heic to png using OpenCV
def heif_to_jpg(image_path):
    heif_file = pillow_heif.open_heif(image_path, convert_hdr_to_8_bit=False, bgr_mode=True)
    np_array = np.asarray(heif_file)
    png_image_path = '.'.join(image_path.split('.')[:-1])+'.png'
    cv2.imwrite(png_image_path, np_array)

def main():
    container_name = 'testing-data'
    blob_name = 'myimage.heic'

    # Download blob as a byte stream
    blob_data = download_blob_as_stream(container_name, blob_name)

    # Process the document
    result = process_document(blob_data)
    
    # Print or handle the JSON result
    print(result)

if __name__ == "__main__":
    main()
