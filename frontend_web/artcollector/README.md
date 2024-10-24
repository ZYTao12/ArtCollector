# ArtCollector Web App

## About the Project

The motivation for having this project is to create an AI-driven solution for art lovers who want to collect and digitize their favorite artworks seen at exhibitions. The full project includes a Django backend, SQLite database, Flutter mobile UI, and employment of Azure FormRecognizer API. Main features allow the user to upload the art tag picture and the app will automatically read the tag into form, helping the user save their favorite artworks and facilitate easy search of art inspiration through text.

Due to time limitations, the React web app version currently only supports a sub-feature of the app, Art Inspiration Search. This feature leverages the Art Institute of Chicago API to present a random artwork for inspiration.

## Run the Web App

- The project was bootstrapped with [Create React App](https://github.com/facebook/create-react-app).
- To install the necessary dependencies, run:
  ```
  npm install
  ```
- To start the app in development mode, run:
  ```
  npm start
  ```
  Open [http://localhost:3000](http://localhost:3000) to view it in your browser.

## Testable Feature

Click the "Find Art Inspiration" button on the homepage to test the Art Inspiration Search feature.

## API Integration

I would like to express my gratitude to the open, public API offered by the Art Institute of Chicago. The randomization of artworks is realized by flooring a random artwork index (ID).

## Credits for AI-Generated Code

I used primarily Claude-3.5-Sonnet to generate the UI JavaScript and CSS codes. Sample prompt:
"Please divide the page into an app header bar and two columns. Divide the right column into five flex rows and place one tile button each in the second, third, and fourth rows."
