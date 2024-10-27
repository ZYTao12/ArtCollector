import os
import configparser
from azure.core.credentials import AzureKeyCredential
from azure.ai.formrecognizer import DocumentAnalysisClient
import json

# import appropriate content from the django api folder

model_id = "artlabelreader-v0"

# test
# formUrl = "https://artcollector.blob.core.windows.net/training-data/IMG_6772.jpg"

def client():
    #config = configparser.ConfigParser()
    #config.read('./client.ini')

    #api_key = config.get('DEFAULT', 'api_key')
    #endpoint = config.get('DEFAULT', 'endpoint')

    client = DocumentAnalysisClient(endpoint=endpoint, credential=AzureKeyCredential(api_key))
    
    return client

def analyze_label(formUrl, artwork_uid):
    document_analysis_client = client()

    poller = document_analysis_client.begin_analyze_document_from_url(model_id, formUrl)
    result = poller.result()

    output = {
        "id": artwork_uid,
        "name": "",
        "date_of_creation": "",
        "medium": "",
        "description": "",
        "author": ""
    }

    for document in result.documents:
        fields = document.fields
        output['name'] = fields['name'].content if 'name' in fields else ""
        output['date_of_creation'] = fields['date_of_creation'].content if 'date_of_creation' in fields else ""
        output['medium'] = fields['medium'].content if 'medium' in fields else " "
        output['description'] = fields['description'].content if 'description' in fields else ""
        output['author'] = fields['author'].content if 'author' in fields else ""

    json_output = json.dumps(output, indent=4, ensure_ascii=False)
    print(json_output)
    return json_output