import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Search } from 'lucide-react';

const Home = () => {
  const [searchQuery, setSearchQuery] = useState('');
  const navigate = useNavigate();

  const handleSearch = (e) => {
    e.preventDefault();
    if (searchQuery.trim()) {
      navigate(`/results?location=${encodeURIComponent(searchQuery)}`);
    }
  };

  return (
    <div className="min-h-screen">
      {/* Hero Section */}
      <section className="relative bg-gradient-to-br from-primary-600 to-primary-800 dark:from-primary-800 dark:to-primary-900 text-white py-20 md:py-32">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center max-w-4xl mx-auto">
            <h1 className="text-4xl md:text-5xl lg:text-6xl font-bold mb-6 animate-fade-in">
              Connect Your Business Anywhere
            </h1>
            <p className="text-xl md:text-2xl mb-12 text-primary-100">
              Cari lokasi gedung Anda untuk mendapatkan penawaran harga instan dari jaringan Netpoint
            </p>

            {/* Search Form */}
            <form onSubmit={handleSearch} className="max-w-3xl mx-auto">
              <div className="relative">
                <input
                  type="text"
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  placeholder="Ketik Nama Gedung / Alamat"
                  className="w-full px-6 py-4 md:py-5 text-lg rounded-full text-gray-900 dark:text-white bg-white dark:bg-gray-800 shadow-2xl focus:outline-none focus:ring-4 focus:ring-primary-300 dark:focus:ring-primary-600 pr-32"
                />
                <button
                  type="submit"
                  className="absolute right-2 top-1/2 transform -translate-y-1/2 bg-primary-600 hover:bg-primary-700 text-white px-6 md:px-8 py-2 md:py-3 rounded-full font-semibold transition-all hover:shadow-lg flex items-center space-x-2"
                >
                  <Search className="w-5 h-5" />
                  <span className="hidden sm:inline">Get Quote</span>
                </button>
              </div>
            </form>
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-20 bg-gradient-to-r from-primary-600 to-primary-700 dark:from-primary-700 dark:to-primary-800">
        <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h2 className="text-3xl md:text-4xl font-bold text-white mb-6">
            Siap Terhubung dengan Netpoint?
          </h2>
          <p className="text-xl text-primary-100 mb-8">
            Mulai pencarian lokasi Anda sekarang dan dapatkan penawaran terbaik
          </p>
          <button
            onClick={() => navigate('/results')}
            className="bg-white text-primary-600 hover:bg-gray-100 px-8 py-4 rounded-full font-bold text-lg transition-all hover:shadow-2xl"
          >
            Mulai Sekarang
          </button>
        </div>
      </section>
    </div>
  );
};

export default Home;
