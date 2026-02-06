import React, { useState, useEffect } from 'react';
import { useSearchParams, useNavigate } from 'react-router-dom';
import { MapPin, Wifi, Shield, Clock, AlertCircle, Search, MessageCircle, FileText } from 'lucide-react';
import { useAuth } from '../contexts/AuthContext';
import jsPDF from 'jspdf';

const API_BASE = import.meta.env.VITE_API_URL || 'http://localhost:8001/api';

const Results = () => {
  const [searchParams] = useSearchParams();
  const navigate = useNavigate();
  const { isAuthenticated, token, user } = useAuth();
  const location = searchParams.get('location');
  const [selectedTier, setSelectedTier] = useState(null);
  const [buildings, setBuildings] = useState([]);
  const [selectedBuilding, setSelectedBuilding] = useState(null);
  const [pricingData, setPricingData] = useState([]);
  const [serviceType, setServiceType] = useState('domestic');
  const [zone, setZone] = useState('Zone 1');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [info, setInfo] = useState('');

  const handleSelect = async (tier) => {
    const message = encodeURIComponent(`Hi Netpoint, I'm interested in the ${tier.tier} package (${tier.serviceType}, ${tier.zone}) for location ${selectedBuilding?.building_name || location}. Please contact me.`);
    const waLink = `https://wa.me/6288293673283?text=${message}`;
    setSelectedTier(tier);
    setInfo('Order recorded. Please download the PDF or continue via WhatsApp.');

    if (!isAuthenticated) {
      window.open(waLink, '_blank');
      navigate('/login');
      return;
    }

    try {
      const payload = {
        locationName: selectedBuilding?.building_name || location,
        locationId: selectedBuilding?.id || null,
        bandwidth_mbps: tier.bandwidth_mbps,
        service_type: tier.serviceType,
        zone: tier.zone,
        notes: `User selected package ${tier.tier} from results page (${location})`,
        whatsapp_number: user?.phone || null,
        source: 'results_page'
      };

      await fetch(`${API_BASE}/orders`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`
        },
        body: JSON.stringify(payload)
      });
    } catch (err) {
      console.error('Failed to save order', err);
    } finally {
      window.open(waLink, '_blank');
    }
  };

  const generatePdf = (tier) => {
    const doc = new jsPDF();
    const lineY = (start, idx) => start + idx * 8;

    doc.setFontSize(16);
    doc.text('Netpoint Package Summary', 14, 16);
    doc.setFontSize(11);
    doc.text(`Date: ${new Date().toLocaleString('en-US')}`, 14, 26);
    doc.text(`Customer: ${user?.name || 'Registered User'}`, 14, 34);

    const locLabel = selectedBuilding?.building_name || location || 'Location not specified';
    doc.text(`Location: ${locLabel}`, 14, 42);
    if (selectedBuilding?.address) doc.text(selectedBuilding.address, 14, 50, { maxWidth: 180 });

    const lines = [
      `Bandwidth: ${tier.bandwidth_mbps || tier.tier}`,
      `Service: ${tier.serviceType}`,
      `Zone: ${tier.zone}`,
      `MRC: ${formatRupiah(tier.basePrice)}`,
      `OTC: ${formatRupiah(tier.otc)}`,
      'Price excludes tax'
    ];

    doc.setFontSize(12);
    doc.text('Package Details', 14, 64);
    doc.setFontSize(11);
    lines.forEach((l, idx) => doc.text(l, 14, lineY(72, idx)));

    doc.setDrawColor(60, 120, 216);
    doc.line(14, 58, 196, 58);

    doc.text('Note: You can attach this document for manager approval.', 14, lineY(72, lines.length + 1));
    doc.save(`netpoint-quote-${tier.bandwidth_mbps || tier.tier}.pdf`);
  };

  const formatRupiah = (value) => {
    if (value === null || value === undefined) return 'N/A';
    return `Rp ${Number(value).toLocaleString('id-ID')}`;
  };

  useEffect(() => {
    const fetchData = async () => {
      if (!location) return;
      setLoading(true);
      setError('');
      try {
        const [bRes, pRes] = await Promise.all([
          fetch(`${API_BASE}/pricing/public/buildings?q=${encodeURIComponent(location)}&limit=5`),
          fetch(`${API_BASE}/pricing/public/pricing?service_type=${serviceType}&zone=${encodeURIComponent(zone)}`)
        ]);

        if (!bRes.ok) throw new Error('Failed to fetch building data');
        if (!pRes.ok) throw new Error('Failed to fetch pricing data');

        const buildingsJson = await bRes.json();
        const pricingJson = await pRes.json();

        const foundBuildings = buildingsJson.buildings || [];
        setBuildings(foundBuildings);
        if ((zone === 'Zone 1' || !zone) && foundBuildings.length) {
          const firstWithZone = foundBuildings.find((b) => b.zone)?.zone;
          if (firstWithZone) {
            setZone(firstWithZone);
          }
        }
        if (!selectedBuilding && foundBuildings.length) {
          setSelectedBuilding(foundBuildings[0]);
        }
        const mappedPricing = (pricingJson.pricing || []).map((p) => ({
          id: p.id,
          bandwidth_mbps: p.bandwidth_mbps,
          tier: `${p.bandwidth_mbps} Mbps`,
          capacity: `${p.bandwidth_mbps} Mbps`,
          sla: '99%',
          setupTime: 'Standard installation',
          basePrice: p.mrc,
          otc: p.otc,
          serviceType: p.service_type,
          zone: p.zone
        }));
        setPricingData(mappedPricing);
      } catch (err) {
        console.error(err);
        setError(err.message || 'An error occurred');
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, [location, serviceType, zone]);

  const handleCustomRequest = () => {
    const message = encodeURIComponent(`Hello, I'd like to request a custom site survey for: ${location || 'a specific location'}`);
    window.open(`https://wa.me/6288293673283?text=${message}`, '_blank');
  };

  if (!location) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-center">
          <Search className="w-16 h-16 text-gray-400 mx-auto mb-4" />
          <h2 className="text-2xl font-bold text-gray-900 dark:text-white mb-4">
            Please search for a location first
          </h2>
          <button
            onClick={() => navigate('/')}
            className="bg-primary-600 hover:bg-primary-700 text-white px-6 py-3 rounded-lg"
          >
            Back to Home
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
              Search Results
            </h1>
          </div>
          <p className="text-xl text-gray-600 dark:text-gray-400">
            Location: <span className="font-semibold">{location}</span>
          </p>
        </div>

        {/* Filter pricing */}
        <div className="max-w-4xl mx-auto mb-8 flex flex-col md:flex-row gap-4 md:items-end md:justify-center">
          <div>
            <label className="block text-sm font-semibold text-gray-700 dark:text-gray-200 mb-1">Service Type</label>
            <select
              value={serviceType}
              onChange={(e) => setServiceType(e.target.value)}
              className="w-full md:w-56 rounded-lg border-gray-300 dark:border-gray-700 dark:bg-gray-800 dark:text-white"
            >
              <option value="domestic">Domestic</option>
              <option value="international">International</option>
              <option value="dia_premium">DIA Premium</option>
              <option value="idia">IDIA</option>
            </select>
          </div>
          <div>
            <label className="block text-sm font-semibold text-gray-700 dark:text-gray-200 mb-1">Zone</label>
            <select
              value={zone}
              onChange={(e) => setZone(e.target.value)}
              className="w-full md:w-40 rounded-lg border-gray-300 dark:border-gray-700 dark:bg-gray-800 dark:text-white"
            >
              <option value="Zone 1">Zone 1</option>
              <option value="Zone 2">Zone 2</option>
              <option value="Zone 3">Zone 3</option>
              <option value="Zone 4">Zone 4</option>
            </select>
          </div>
        </div>

        {(error || info) && (
            <div className="max-w-4xl mx-auto mb-6 bg-red-50 border border-red-200 text-red-700 p-4 rounded-lg">
            <AlertCircle className="inline mr-2" size={18} />{error || info}
          </div>
        )}

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
                  <p className="text-sm text-gray-500 dark:text-gray-400 mb-2">{tier.serviceType?.toUpperCase()} • {tier.zone}</p>

                  {/* Price */}
                  <div className="mb-6">
                    {tier.basePrice ? (
                      <>
                        <div className="flex items-baseline">
                          <span className="text-4xl font-bold text-primary-600 dark:text-primary-400">
                            {formatRupiah(tier.basePrice)}
                          </span>
                          <span className="text-gray-600 dark:text-gray-400 ml-2">/month</span>
                        </div>
                        <div className="text-sm text-gray-500 dark:text-gray-400">OTC: {formatRupiah(tier.otc)}</div>
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
                      Included Features:
                    </h4>
                    <ul className="space-y-2">
                      <li className="flex items-start text-sm text-gray-600 dark:text-gray-400">• Bandwidth: {tier.capacity}</li>
                      <li className="flex items-start text-sm text-gray-600 dark:text-gray-400">• Zone: {tier.zone}</li>
                      <li className="flex items-start text-sm text-gray-600 dark:text-gray-400">• Service: {tier.serviceType}</li>
                    </ul>
                  </div>

                  {/* Actions */}
                  <div className="space-y-3">
                    <button
                      onClick={() => handleSelect(tier)}
                      className="w-full bg-primary-600 hover:bg-primary-700 text-white py-3 rounded-lg font-semibold transition-colors"
                    >
                      {tier.basePrice ? 'Select Package' : 'Contact Us'}
                    </button>
                  </div>
                </div>
              </div>
            );
          })}
        </div>

        {/* Your Order */}
        {selectedTier && (
          <div className="max-w-4xl mx-auto mb-8 bg-white dark:bg-gray-800 rounded-2xl shadow-lg p-6">
            <div className="flex items-center mb-4">
              <FileText className="w-5 h-5 text-primary-600 dark:text-primary-400 mr-2" />
              <h3 className="text-xl font-bold text-gray-900 dark:text-white">Your Order</h3>
            </div>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm text-gray-700 dark:text-gray-300">
              <div><span className="font-semibold">Location:</span> {selectedBuilding?.building_name || location || '-'}</div>
              <div><span className="font-semibold">Address:</span> {selectedBuilding?.address || 'N/A'}</div>
              <div><span className="font-semibold">Bandwidth:</span> {selectedTier.tier}</div>
              <div><span className="font-semibold">Service:</span> {selectedTier.serviceType}</div>
              <div><span className="font-semibold">Zone:</span> {selectedTier.zone}</div>
              <div><span className="font-semibold">MRC:</span> {formatRupiah(selectedTier.basePrice)}</div>
              <div><span className="font-semibold">OTC:</span> {formatRupiah(selectedTier.otc)}</div>
              <div className="text-xs text-gray-500 dark:text-gray-400">Prices exclude tax</div>
            </div>
            <div className="mt-4 flex flex-wrap gap-3">
              <button
                onClick={() => generatePdf(selectedTier)}
                className="px-4 py-2 bg-primary-600 hover:bg-primary-700 text-white rounded-lg flex items-center gap-2"
              >
                <FileText className="w-4 h-4" /> Download PDF
              </button>
              <button
                onClick={handleCustomRequest}
                className="px-4 py-2 bg-green-600 hover:bg-green-700 text-white rounded-lg flex items-center gap-2"
              >
                <MessageCircle className="w-4 h-4" /> Contact via WhatsApp
              </button>
            </div>
          </div>
        )}

        {/* Building search results */}
        <div className="max-w-5xl mx-auto bg-white dark:bg-gray-800 rounded-2xl shadow-lg p-6">
          <div className="flex items-center mb-4">
            <MapPin className="w-5 h-5 text-primary-600 dark:text-primary-400 mr-2" />
            <h3 className="text-xl font-bold text-gray-900 dark:text-white">Building Results</h3>
          </div>
          {loading ? (
            <div className="text-gray-500 dark:text-gray-400">Loading data...</div>
          ) : buildings.length === 0 ? (
            <div className="text-gray-500 dark:text-gray-400">No buildings found for this keyword.</div>
          ) : (
            <ul className="divide-y divide-gray-200 dark:divide-gray-700">
              {buildings.map((b) => (
                <li
                  key={b.id}
                  onClick={() => setSelectedBuilding(b)}
                  className={`py-3 cursor-pointer ${selectedBuilding?.id === b.id ? 'bg-primary-50 dark:bg-primary-900/30 rounded-lg px-3' : ''}`}
                >
                  <div className="font-semibold text-gray-900 dark:text-white">{b.building_name}</div>
                  <div className="text-sm text-gray-600 dark:text-gray-400">{b.address}</div>
                  <div className="text-xs text-gray-500 dark:text-gray-500">{b.city || 'N/A'} • {b.zone || 'Zone ?'}</div>
                </li>
              ))}
            </ul>
          )}
        </div>
        
        {/* Custom Request Section */}
        <div className="bg-gradient-to-r from-gray-50 to-gray-100 dark:from-gray-800 dark:to-gray-900 rounded-2xl p-8 shadow-lg mt-8">
          <div className="flex items-start mb-6">
            <AlertCircle className="w-8 h-8 text-primary-600 dark:text-primary-400 mr-4 flex-shrink-0" />
            <div>
              <h3 className="text-2xl font-bold text-gray-900 dark:text-white mb-2">
                Location Not Listed?
              </h3>
              <p className="text-gray-600 dark:text-gray-400 mb-4">
                Don't worry, the Netpoint integration team has broad access to nationwide providers. 
                We will run an Off-Net Feasibility Study tailored for you.
              </p>
              <p className="text-sm text-gray-500 dark:text-gray-500 mb-4">
                Contact us via WhatsApp to request a custom survey.
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
