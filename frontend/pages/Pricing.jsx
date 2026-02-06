import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';

export default function PricingPage() {
  const [buildings, setBuildings] = useState([]);
  const [pricing, setPricing] = useState([]);
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedBuilding, setSelectedBuilding] = useState(null);
  const [quote, setQuote] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  // Quote form state
  const [bandwidth, setBandwidth] = useState('');
  const [serviceType, setServiceType] = useState('domestic');
  const [zone, setZone] = useState('Zone 1');

  const navigate = useNavigate();
  const apiUrl = import.meta.env.VITE_API_URL || '/api';

  useEffect(() => {
    const token = localStorage.getItem('token');
    const user = JSON.parse(localStorage.getItem('user') || '{}');

    if (!token || user.role !== 'admin') {
      navigate('/login');
      return;
    }

    fetchBuildings();
    fetchPricing();
  }, []);

  const fetchBuildings = async (search = '') => {
    setLoading(true);
    try {
      const token = localStorage.getItem('token');
      const url = search 
        ? `${apiUrl}/pricing/buildings?search=${encodeURIComponent(search)}&limit=100`
        : `${apiUrl}/pricing/buildings?limit=100`;
      
      const response = await fetch(url, {
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        }
      });

      if (!response.ok) throw new Error('Failed to fetch buildings');

      const data = await response.json();
      setBuildings(data.buildings || []);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const fetchPricing = async () => {
    try {
      const token = localStorage.getItem('token');
      const response = await fetch(`${apiUrl}/pricing/pricing`, {
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        }
      });

      if (!response.ok) throw new Error('Failed to fetch pricing');

      const data = await response.json();
      setPricing(data);
    } catch (err) {
      console.error('Error fetching pricing:', err);
    }
  };

  const handleSearch = (e) => {
    e.preventDefault();
    fetchBuildings(searchTerm);
  };

  const handleGenerateQuote = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError('');
    setQuote(null);

    try {
      const token = localStorage.getItem('token');
      const response = await fetch(`${apiUrl}/pricing/quote`, {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          bandwidth_mbps: parseInt(bandwidth),
          service_type: serviceType,
          zone: zone,
          building_id: selectedBuilding?.id || null
        })
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.error || 'Failed to generate quote');
      }

      const data = await response.json();
      setQuote(data);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const formatCurrency = (amount) => {
    return new Intl.NumberFormat('id-ID', {
      style: 'currency',
      currency: 'IDR',
      minimumFractionDigits: 0
    }).format(amount);
  };

  const bandwidthOptions = [2, 4, 6, 8, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000];

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <h1 className="text-3xl font-bold text-gray-900 dark:text-white mb-8">
          Building & Pricing Management
        </h1>

        {error && (
          <div className="mb-4 p-4 bg-red-50 border border-red-200 rounded-lg text-red-700">
            {error}
          </div>
        )}

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
          {/* Buildings Search Section */}
          <div className="bg-white dark:bg-gray-800 rounded-lg shadow-md p-6">
            <h2 className="text-xl font-semibold text-gray-900 dark:text-white mb-4">
              Search Buildings
            </h2>

            <form onSubmit={handleSearch} className="mb-6">
              <div className="flex gap-2">
                <input
                  type="text"
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  placeholder="Search building name or address..."
                  className="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent dark:bg-gray-700 dark:border-gray-600 dark:text-white"
                />
                <button
                  type="submit"
                  className="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
                  disabled={loading}
                >
                  {loading ? 'Searching...' : 'Search'}
                </button>
              </div>
            </form>

            <div className="max-h-96 overflow-y-auto space-y-2">
              {buildings.length === 0 ? (
                <p className="text-gray-500 dark:text-gray-400 text-center py-8">
                  No buildings found. Try searching...
                </p>
              ) : (
                buildings.map((building) => (
                  <div
                    key={building.id}
                    onClick={() => setSelectedBuilding(building)}
                    className={`p-4 border rounded-lg cursor-pointer transition-colors ${
                      selectedBuilding?.id === building.id
                        ? 'border-blue-500 bg-blue-50 dark:bg-blue-900/20'
                        : 'border-gray-200 hover:border-gray-300 dark:border-gray-700 dark:hover:border-gray-600'
                    }`}
                  >
                    <div className="font-semibold text-gray-900 dark:text-white">
                      {building.building_name}
                    </div>
                    <div className="text-sm text-gray-600 dark:text-gray-400 mt-1">
                      {building.address}
                    </div>
                    <div className="flex gap-2 mt-2">
                      <span className="text-xs px-2 py-1 bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400 rounded">
                        {building.zone || 'No Zone'}
                      </span>
                      <span className="text-xs px-2 py-1 bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-300 rounded">
                        {building.city || 'No City'}
                      </span>
                    </div>
                  </div>
                ))
              )}
            </div>
          </div>

          {/* Quote Generator Section */}
          <div className="bg-white dark:bg-gray-800 rounded-lg shadow-md p-6">
            <h2 className="text-xl font-semibold text-gray-900 dark:text-white mb-4">
              Generate Quote
            </h2>

            {selectedBuilding && (
              <div className="mb-4 p-4 bg-blue-50 dark:bg-blue-900/20 rounded-lg">
                <div className="text-sm text-gray-600 dark:text-gray-400">Selected Building:</div>
                <div className="font-semibold text-gray-900 dark:text-white">
                  {selectedBuilding.building_name}
                </div>
                <div className="text-sm text-gray-600 dark:text-gray-400">
                  {selectedBuilding.address}
                </div>
              </div>
            )}

            <form onSubmit={handleGenerateQuote} className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                  Bandwidth (Mbps)
                </label>
                <select
                  value={bandwidth}
                  onChange={(e) => setBandwidth(e.target.value)}
                  required
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent dark:bg-gray-700 dark:border-gray-600 dark:text-white"
                >
                  <option value="">Select bandwidth...</option>
                  {bandwidthOptions.map(bw => (
                    <option key={bw} value={bw}>{bw} Mbps</option>
                  ))}
                </select>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                  Service Type
                </label>
                <select
                  value={serviceType}
                  onChange={(e) => setServiceType(e.target.value)}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent dark:bg-gray-700 dark:border-gray-600 dark:text-white"
                >
                  <option value="domestic">Domestic Ethernet</option>
                  <option value="international">International Ethernet</option>
                  <option value="dia_premium">DIA Premium 1:1</option>
                  <option value="idia">IDIA Up To USD</option>
                </select>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                  Zone
                </label>
                <select
                  value={zone}
                  onChange={(e) => setZone(e.target.value)}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent dark:bg-gray-700 dark:border-gray-600 dark:text-white"
                >
                  <option value="Zone 1">Zone 1</option>
                  <option value="Zone 2">Zone 2</option>
                  <option value="Zone 3">Zone 3</option>
                  <option value="Zone 4">Zone 4</option>
                </select>
              </div>

              <button
                type="submit"
                disabled={loading || !bandwidth}
                className="w-full px-6 py-3 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors disabled:bg-gray-400 disabled:cursor-not-allowed"
              >
                {loading ? 'Generating...' : 'Generate Quote'}
              </button>
            </form>

            {quote && (
              <div className="mt-6 p-6 bg-green-50 dark:bg-green-900/20 rounded-lg border-2 border-green-500">
                <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">
                  Quote Generated
                </h3>
                
                <div className="space-y-3">
                  <div className="flex justify-between">
                    <span className="text-gray-600 dark:text-gray-400">Bandwidth:</span>
                    <span className="font-semibold text-gray-900 dark:text-white">
                      {quote.quote.bandwidth_mbps} Mbps
                    </span>
                  </div>
                  
                  <div className="flex justify-between">
                    <span className="text-gray-600 dark:text-gray-400">Service Type:</span>
                    <span className="font-semibold text-gray-900 dark:text-white capitalize">
                      {quote.quote.service_type.replace('_', ' ')}
                    </span>
                  </div>
                  
                  <div className="flex justify-between">
                    <span className="text-gray-600 dark:text-gray-400">Zone:</span>
                    <span className="font-semibold text-gray-900 dark:text-white">
                      {quote.quote.zone}
                    </span>
                  </div>
                  
                  <div className="border-t border-green-300 dark:border-green-700 my-3"></div>
                  
                  <div className="flex justify-between">
                    <span className="text-gray-600 dark:text-gray-400">One Time Charge (OTC):</span>
                    <span className="font-bold text-lg text-gray-900 dark:text-white">
                      {formatCurrency(quote.quote.otc)}
                    </span>
                  </div>
                  
                  <div className="flex justify-between">
                    <span className="text-gray-600 dark:text-gray-400">Monthly Recurring (MRC):</span>
                    <span className="font-bold text-lg text-green-600 dark:text-green-400">
                      {formatCurrency(quote.quote.mrc)}
                    </span>
                  </div>
                  
                  {quote.building && (
                    <>
                      <div className="border-t border-green-300 dark:border-green-700 my-3"></div>
                      <div>
                        <span className="text-gray-600 dark:text-gray-400 block mb-1">Location:</span>
                        <span className="font-semibold text-gray-900 dark:text-white block">
                          {quote.building.building_name}
                        </span>
                        <span className="text-sm text-gray-600 dark:text-gray-400">
                          {quote.building.address}
                        </span>
                      </div>
                    </>
                  )}
                </div>

                <div className="mt-4 text-xs text-gray-500 dark:text-gray-400">
                  Price Row ID: {quote.quote.price_list_id} | Source: {quote.log?.source || 'admin_quote'}
                </div>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
