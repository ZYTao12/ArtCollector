# ArtCollector

1. front-end

```
flutter clean
flutter pub get
flutter run
```

progress: 

(2024.8.8) added the result page (for testing purpose) to show the extracted json result

(2024.8.7) upload selected image to Azure Storage Account

(2024.8.2) home page with upload button & access to photo gallery (image picker)

(2024.7.20) login page (unstyled)

2. back-end

```python3 manage.py runserver```

progress:

(2024.8.8) added the flask api to retrieve processed results and load them to a url

(2024.8.4) built Azure AI client, customized Azure Document Intelligence ready-to-go

(2024.7.20) minimum django db (artwork & folder models, admin site)


# TO-DO
- Editable form page to load extracted text
- relational database: (user) -> artwork -> folder
- User model, user auth, etc.

# UI sample images (created with FlutterFlow)
Sign-up page:

![sign-up-ui](https://github.com/ZYTao12/ArtCollector/blob/main/frontend/artcollector/design/signuppage.jpeg)

Sign-in page:
![sign-in-ui](https://github.com/ZYTao12/ArtCollector/blob/main/frontend/artcollector/design/signinpage.jpeg)

Homepage:
![homepage-ui](https://github.com/ZYTao12/ArtCollector/blob/main/frontend/artcollector/design/homepage.jpeg)

Search page:
![search-page-ui](https://github.com/ZYTao12/ArtCollector/blob/main/frontend/artcollector/design/searchpage.jpeg)

Upload page:
![upload-artwork-ui](https://github.com/ZYTao12/ArtCollector/blob/main/frontend/artcollector/design/uploadartworkpage.jpeg)

Folder page(s):
![folder-a](https://github.com/ZYTao12/ArtCollector/blob/main/frontend/artcollector/design/foldercontentpage_a.jpeg)
![folder-b](https://github.com/ZYTao12/ArtCollector/blob/main/frontend/artcollector/design/foldercontentpage_b.jpeg)
