import React from 'react';
import { BrowserRouter as Router, Route, Routes, Link } from 'react-router-dom';
import './App.css'; // Make sure to create this CSS file
import Homepage from './pages/homepage';
import Overview from './pages/overview';
import RandomArt from './pages/randomart';

function App() {
  return (
    <Router>
        <Routes>
          <Route path="/" element={<Homepage />} />
          <Route path="/overview" element={<Overview />} />
          <Route path="/randomart" element={<RandomArt />} />
        </Routes>
    </Router>
  );
}

export default App;
