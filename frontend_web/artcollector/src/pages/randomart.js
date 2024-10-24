import React, { useState, useEffect } from 'react';
import './randomart.css';

function RandomArt() {
  const [artwork, setArtwork] = useState(null);
  const [error, setError] = useState(null);

  useEffect(() => {
    // Fetch a random artwork
    const fetchRandomArtwork = async () => {
      try {
        const response = await fetch('https://api.artic.edu/api/v1/artworks');
        const data = await response.json();
        const artworks = data.data;
        const randomIndex = Math.floor(Math.random() * artworks.length);
        const randomArtwork = artworks[randomIndex];
        setArtwork(randomArtwork);
      } catch (err) {
        setError('Failed to fetch artwork');
      }
    };

    fetchRandomArtwork();
  }, []);

  if (error) {
    return <div className="error">{error}</div>;
  }

  if (!artwork) {
    return <div className="loading">Loading...</div>;
  }

  return (
    <div className="random-art-container">
      <div className="artwork-content" style={{ display: 'flex', alignItems: 'center' }}>
        <img
          className="artwork-image"
          src={`https://www.artic.edu/iiif/2/${artwork.image_id}/full/843,/0/default.jpg`}
          alt={artwork.title}
          style={{ marginRight: '20px' }}
        />
        <div className="artwork-details">
          <h2>{artwork.title}</h2>
          <p><strong>Artist:</strong> {artwork.artist_display}</p>
          <p><strong>Date:</strong> {artwork.date_display}</p>
          <p><strong>Medium:</strong> {artwork.medium_display}</p>
          <p><strong>Dimensions:</strong> {artwork.dimensions}</p>
          <p><strong>Main Reference Number:</strong> {artwork.main_reference_number}</p>
        </div>
      </div>
    </div>
  );
}

export default RandomArt;
