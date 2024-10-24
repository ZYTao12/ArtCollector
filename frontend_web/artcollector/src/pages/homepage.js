import React from 'react';
import { Link } from 'react-router-dom';
import './homepage.css';

function Homepage() {
  return (
    <div className="App">
      <div className="two-column-layout">
        <div className="left-column">
          <img src={`${process.env.PUBLIC_URL}/assets/home_image.jpeg`} alt="Home" className="home-image" />
        </div>
        <div className="right-column">
         <div className="flex-row"></div>
          <div className="flex-row">
            <Link to="/overview" className="button-link">
              <button className="tile-button">Visit My Collection</button>
            </Link>
          </div>
          <div className="flex-row">
            <button className="tile-button">Upload Art Image</button>
          </div>
          <div className="flex-row">
            <Link to="/randomart" className="button-link">
              <button className="tile-button">Find Art Inspiration</button>
            </Link>
          </div>
          <div className="flex-row"></div>
        </div>
      </div>
    </div>
  );
}

export default Homepage;
