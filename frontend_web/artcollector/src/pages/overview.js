import React, { useState, useEffect } from 'react';
import './overview.css';

function Overview() {
  const [artworks, setArtworks] = useState([]);
  const [searchTerm, setSearchTerm] = useState('');
  const [error, setError] = useState(null);

  useEffect(() => {
    fetchArtworks();
  }, []);

  const fetchArtworks = async () => {
    try {
      const response = await fetch('http://127.0.0.1:8000/api/artwork');
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      const data = await response.json();
      if (!Array.isArray(data)) {
        throw new Error('API response is not an array');
      }
      setArtworks(data);
    } catch (error) {
      console.error('Error fetching artworks:', error);
      setError('Failed to fetch artworks. Please try again later.');
    }
  };

  const filteredArtworks = artworks.filter(artwork =>
    artwork && artwork.title && typeof artwork.title === 'string' &&
    artwork.title.toLowerCase().includes(searchTerm.toLowerCase())
  );

  if (error) {
    return <div className="error-message">{error}</div>;
  }

  return (
    <div className="overview-container">
      <header className="app-header">
        <h1>Art Collection Overview</h1>
      </header>
      <div className="search-bar">
        <input
          type="text"
          placeholder="Search artworks..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
        />
      </div>
      <div className="artwork-grid">
        {filteredArtworks.map((artwork) => (
          <div key={artwork.id || Math.random()} className="artwork-item">
            <div className="artwork-image-placeholder"></div>
            <h3>{artwork.title || 'Untitled'}</h3>
          </div>
        ))}
      </div>
    </div>
  );
}

export default Overview;
