import React, { useState, useEffect } from 'react';
import { useSearchParams, useNavigate } from 'react-router-dom';
import { MapPin, Wifi, Shield, Clock, AlertCircle, Search, MessageCircle } from 'lucide-react';
import { useAuth } from '../contexts/AuthContext';

const Results = () => {
  const [searchParams] = useSearchParams();
  const navigate = useNavigate();
  const { isAuthenticated } = useAuth();
  const location = searchParams.get('location');
  const [selectedTier, setSelectedTier] = useState(null);
  const [showCustomRequest, setShowCustomRequest] = useState(false);

  // Mock data untuk pricing
  const pricingData = [
    {
      id: 1,
      tier: 'Netpoint Basic',
      capacity: '50 Mbps',
      sla: '99.0%',
      setupTime: '7 Hari',
      basePrice: 1500000,
      features: [
        'Bandwidth up to 50 Mbps',
        'SLA 99.0%',
        'Email Support',
        'Setup dalam 7 hari kerja'
      ]
    },
    {
      id: 2,
      tier: 'Netpoint Business',
      capacity: '100 Mbps',
      sla: '99.7%',
      setupTime: '5 Hari',
      basePrice: 3000000,
      popular: true,
      features: [
        'Bandwidth up to 100 Mbps',
        'SLA 99.7%',
        '24/7 Phone Support',
        'Setup dalam 5 hari kerja',
        'Dedicated Account Manager'
      ]
    },
    {
      id: 3,
      tier: 'Netpoint Enterprise',
      capacity: '1 Gbps',
      sla: '99.9%',
      setupTime: 'Custom',
      basePrice: null,
      features: [
        'Bandwidth up to 1 Gbps',
        'SLA 99.9%',
        '24/7 Priority Support',
        'Custom Setup Timeline',
        'Dedicated Technical Team',
        'Custom Configuration'
      ]
    }
  ];

  const handleSelect = (tier) => {
    if (!isAuthenticated) {
      alert('Silakan login atau daftar terlebih dahulu untuk melanjutkan');
      navigate('/login');
      return;
    }
    setSelectedTier(tier);
    alert(`Anda memilih ${tier.tier}. Tim kami akan segera menghubungi Anda.`);
  };

  const handleCustomRequest = () => {
    const message = encodeURIComponent(`Halo, saya ingin request survey lokasi khusus untuk: ${location || 'lokasi tertentu'}`);
    window.open(`https://wa.me/6288293673283?text=${message}`, '_blank');
  };

  if (!location) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-center">
          <Search className="w-16 h-16 text-gray-400 mx-auto mb-4" />
          <h2 className="text-2xl font-bold text-gray-900 dark:text-white mb-4">
            Silakan cari lokasi terlebih dahulu
          </h2>
          <button
            onClick={() => navigate('/')}
            className="bg-primary-600 hover:bg-primary-700 text-white px-6 py-3 rounded-lg"
          >
            Kembali ke Beranda
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-7xl mx-auto">
        {/* Header */}
        <div className="text-center mb-12">
          <div className="flex items-center justify-center mb-4">
            <MapPin className="w-6 h-6 text-primary-600 dark:text-primary-400 mr-2" />
            <h1 className="text-3xl md:text-4xl font-bold text-gray-900 dark:text-white">
              Hasil Pencarian
            </h1>
          </div>
          <p className="text-xl text-gray-600 dark:text-gray-400">
            Lokasi: <span className="font-semibold">{location}</span>
          </p>
        </div>

        {/* Pricing Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 mb-12">
          {pricingData.map((tier) => {
            return (
              <div
                key={tier.id}
                className={`relative bg-white dark:bg-gray-800 rounded-2xl shadow-xl overflow-hidden transition-transform hover:scale-105 ${
                  tier.popular ? 'ring-4 ring-primary-500' : ''
                }`}
              >
                {tier.popular && (
                  <div className="absolute top-0 right-0 bg-primary-600 text-white px-4 py-1 text-sm font-semibold rounded-bl-lg">
                    Popular
                  </div>
                )}

                <div className="p-8">
                  {/* Tier Name */}
                  <h3 className="text-2xl font-bold text-gray-900 dark:text-white mb-2">
                    {tier.tier}
                  </h3>

                  {/* Price */}
                  <div className="mb-6">
                    {tier.basePrice ? (
                      <>
                        <div className="flex items-baseline">
                          <span className="text-4xl font-bold text-primary-600 dark:text-primary-400">
                            Rp {tier.basePrice.toLocaleString('id-ID')}
                          </span>
                          <span className="text-gray-600 dark:text-gray-400 ml-2">/bulan</span>
                        </div>
                      </>
                    ) : (
                      <div className="text-2xl font-bold text-gray-900 dark:text-white">
                        Custom Quote
                      </div>
                    )}
                  </div>

                  {/* Specs */}
                  <div className="space-y-3 mb-6">
                    <div className="flex items-center">
                      <Wifi className="w-5 h-5 text-primary-600 dark:text-primary-400 mr-3" />
                      <span className="text-gray-700 dark:text-gray-300">{tier.capacity}</span>
                    </div>
                    <div className="flex items-center">
                      <Shield className="w-5 h-5 text-primary-600 dark:text-primary-400 mr-3" />
                      <span className="text-gray-700 dark:text-gray-300">SLA {tier.sla}</span>
                    </div>
                    <div className="flex items-center">
                      <Clock className="w-5 h-5 text-primary-600 dark:text-primary-400 mr-3" />
                      <span className="text-gray-700 dark:text-gray-300">{tier.setupTime}</span>
                    </div>
                  </div>

                  {/* Features */}
                  <div className="border-t border-gray-200 dark:border-gray-700 pt-6 mb-6">
                    <h4 className="font-semibold text-gray-900 dark:text-white mb-3">
                      Fitur Termasuk:
                    </h4>
                    <ul className="space-y-2">
                      {tier.features.map((feature, idx) => (
                        <li key={idx} className="flex items-start">
                          <span className="text-primary-600 dark:text-primary-400 mr-2">✓</span>
                          <span className="text-sm text-gray-600 dark:text-gray-400">{feature}</span>
                        </li>
                      ))}
                    </ul>
                  </div>

                  {/* Actions */}
                  <div className="space-y-3">
                    <button
                      onClick={() => handleSelect(tier)}
                      className="w-full bg-primary-600 hover:bg-primary-700 text-white py-3 rounded-lg font-semibold transition-colors"
                    >
                      {tier.basePrice ? 'Pilih Paket' : 'Hubungi Kami'}
                    </button>
                  </div>
                </div>
              </div>
            );
          })}
        </div>

        {/* Custom Request Section */}
        <div className="bg-gradient-to-r from-gray-50 to-gray-100 dark:from-gray-800 dark:to-gray-900 rounded-2xl p-8 shadow-lg">
          <div className="flex items-start mb-6">
            <AlertCircle className="w-8 h-8 text-primary-600 dark:text-primary-400 mr-4 flex-shrink-0" />
            <div>
              <h3 className="text-2xl font-bold text-gray-900 dark:text-white mb-2">
                Lokasi Tidak Terdaftar?
              </h3>
              <p className="text-gray-600 dark:text-gray-400 mb-4">
                Jangan khawatir, tim integrator Netpoint memiliki akses luas ke berbagai provider nasional. 
                Kami akan melakukan Off-Net Feasibility Study khusus untuk Anda.
              </p>
              <p className="text-sm text-gray-500 dark:text-gray-500 mb-4">
                Hubungi kami melalui WhatsApp untuk request custom survey
              </p>
            </div>
          </div>

          <button
            onClick={handleCustomRequest}
            className="bg-green-600 hover:bg-green-700 text-white px-8 py-3 rounded-lg font-semibold transition-colors flex items-center space-x-2"
          >
            <MessageCircle className="w-5 h-5" />
            <span>Chat via WhatsApp</span>
          </button>
        </div>
      </div>
    </div>
  );
};

export default Results;
