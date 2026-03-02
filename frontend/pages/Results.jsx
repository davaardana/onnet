import React, { useState, useEffect } from 'react';
import { useSearchParams, useNavigate } from 'react-router-dom';
import { MapPin, Wifi, Shield, Clock, AlertCircle, Search, MessageCircle, FileText, ExternalLink } from 'lucide-react';
import { useAuth } from '../contexts/AuthContext';
import jsPDF from 'jspdf';

const API_BASE = import.meta.env.VITE_API_URL || '/api';
const PPN_RATE = 0.11;          // PPN 11%
const withPPN = (price) => price ? Number(price) * (1 + PPN_RATE) : null;
const ppnAmount = (price) => price ? Number(price) * PPN_RATE : null;

const SkeletonCard = () => (
  <div className="bg-white dark:bg-gray-800 rounded-2xl shadow-xl overflow-hidden animate-pulse">
    <div className="p-8">
      <div className="h-7 bg-gray-200 dark:bg-gray-700 rounded w-2/3 mb-3" />
      <div className="h-4 bg-gray-200 dark:bg-gray-700 rounded w-1/2 mb-6" />
      <div className="h-10 bg-gray-200 dark:bg-gray-700 rounded w-3/4 mb-2" />
      <div className="h-4 bg-gray-200 dark:bg-gray-700 rounded w-1/3 mb-6" />
      <div className="space-y-3 mb-6">
        <div className="h-4 bg-gray-200 dark:bg-gray-700 rounded" />
        <div className="h-4 bg-gray-200 dark:bg-gray-700 rounded" />
        <div className="h-4 bg-gray-200 dark:bg-gray-700 rounded" />
      </div>
      <div className="h-11 bg-gray-200 dark:bg-gray-700 rounded-lg" />
    </div>
  </div>
);

const SERVICE_LABELS = {
  dia: 'Dedicated Internet Access (DIA)',
  broadband: 'Broadband Internet',
  metronet: 'Metro Ethernet Local Loop',
  dc2dc: 'DC to DC Interconnection',
  darkfiber: 'Dark Fiber',
};

const P2P_SERVICES = ['metronet', 'dc2dc', 'darkfiber'];

const Results = () => {
  const [searchParams] = useSearchParams();
  const navigate = useNavigate();
  const { isAuthenticated, user, apiFetch } = useAuth();
  const location = searchParams.get('location');
  const aEnd = searchParams.get('aEnd') || location;
  const bEnd = searchParams.get('bEnd') || '';
  const serviceCategory = searchParams.get('serviceCategory') || '';
  const reqBandwidth = searchParams.get('bandwidth') || '';
  const requestedBandwidth = Number.parseInt(reqBandwidth, 10);
  const hasRequestedBandwidth = Number.isInteger(requestedBandwidth) && requestedBandwidth > 0;
  const isP2P = P2P_SERVICES.includes(serviceCategory);

  const [selectedTier, setSelectedTier] = useState(null);
  const [buildings, setBuildings] = useState([]);
  const [bEndBuildings, setBEndBuildings] = useState([]);
  const [selectedBuilding, setSelectedBuilding] = useState(null);
  const [selectedBEndBuilding, setSelectedBEndBuilding] = useState(null);
  const [pricingData, setPricingData] = useState([]);
  const [serviceType, setServiceType] = useState('domestic');
  const [zone, setZone] = useState('Zone 1');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [info, setInfo] = useState('');

  const handleSelect = async (tier) => {
    const locLabel = isP2P
      ? `A-End: ${aEnd} → B-End: ${bEnd}`
      : (selectedBuilding?.building_name || location);
    const svcLabel = SERVICE_LABELS[serviceCategory] || serviceCategory || 'Internet';
    const message = encodeURIComponent(
      `Hi Netpoint, I'm interested in ${svcLabel} – ${tier.tier} package (${tier.serviceType}, ${tier.zone}).\nLocation: ${locLabel}.\nPlease contact me.`
    );
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
        locationName: isP2P ? `${aEnd} → ${bEnd}` : (selectedBuilding?.building_name || location),
        // locationId references locations table, not buildings — do not pass buildings.id here
        locationId: null,
        bandwidth_mbps: tier.bandwidth_mbps,
        service_type: tier.serviceType,
        service_category: serviceCategory || null,
        zone: tier.zone,
        notes: `[${SERVICE_LABELS[serviceCategory] || serviceCategory}] ${tier.tier} — A: ${aEnd || location}${bEnd ? ` B: ${bEnd}` : ''}`,
        whatsapp_number: user?.phone || null,
        source: 'results_page'
      };

      await apiFetch(`${API_BASE}/orders`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
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

    if (isP2P) {
      doc.text(`Service: ${SERVICE_LABELS[serviceCategory] || serviceCategory}`, 14, 42);
      doc.text(`A-End: ${aEnd || '-'}`, 14, 50);
      doc.text(`B-End: ${bEnd || '-'}`, 14, 58);
    } else {
      doc.text(`Service: ${SERVICE_LABELS[serviceCategory] || 'Internet Service'}`, 14, 42);
      const locLabel = selectedBuilding?.building_name || location || 'Location not specified';
      doc.text(`Location: ${locLabel}`, 14, 50, { maxWidth: 180 });
      if (selectedBuilding?.address) doc.text(selectedBuilding.address, 14, 58, { maxWidth: 180 });
    }

    const lines = [
      `Bandwidth      : ${tier.bandwidth_mbps || tier.tier}`,
      `Service Type   : ${tier.serviceType}`,
      `Zone           : ${tier.zone}`,
      `Currency       : USD (VAT 11% incl.)`,
      '',
      `MRC (excl. VAT): ${formatUSD(tier.basePrice)}`,
      `VAT 11%        : ${formatUSD(ppnAmount(tier.basePrice))}`,
      `Total MRC      : ${formatUSD(withPPN(tier.basePrice))}`,
      '',
      `OTC (excl. VAT): ${formatUSD(tier.otc)}`,
      `VAT 11%        : ${formatUSD(ppnAmount(tier.otc))}`,
      `Total OTC      : ${formatUSD(withPPN(tier.otc))}`,
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

  const formatUSD = (usdValue) => {
    if (usdValue === null || usdValue === undefined) return 'N/A';
    return `$${Number(usdValue).toLocaleString('en-US', { minimumFractionDigits: 0, maximumFractionDigits: 0 })}`;
  };

  const getMapsUrl = (address, buildingName = '') => {
    const query = encodeURIComponent([buildingName, address].filter(Boolean).join(', '));
    return `https://www.google.com/maps/search/?api=1&query=${query}`;
  };

  useEffect(() => {
    const fetchData = async () => {
      if (!location) return;
      setLoading(true);
      setError('');
      try {
        const requests = [
          fetch(`${API_BASE}/pricing/public/buildings?q=${encodeURIComponent(location)}&limit=5`),
          fetch(
            `${API_BASE}/pricing/public/pricing?service_type=${serviceType}&zone=${encodeURIComponent(zone)}${
              hasRequestedBandwidth ? `&bandwidth_mbps=${requestedBandwidth}` : ''
            }`
          ),
        ];
        if (isP2P && bEnd) {
          requests.push(fetch(`${API_BASE}/pricing/public/buildings?q=${encodeURIComponent(bEnd)}&limit=5`));
        }

        const results = await Promise.all(requests);
        const [bRes, pRes, bEndRes] = results;

        if (!bRes.ok) throw new Error('Failed to fetch building data');
        if (!pRes.ok) throw new Error('Failed to fetch pricing data');

        const buildingsJson = await bRes.json();
        const pricingJson = await pRes.json();

        const foundBuildings = buildingsJson.buildings || [];
        setBuildings(foundBuildings);

        if (bEndRes) {
          const bEndJson = await bEndRes.json();
          const foundBEnd = bEndJson.buildings || [];
          setBEndBuildings(foundBEnd);
          if (!selectedBEndBuilding && foundBEnd.length) setSelectedBEndBuilding(foundBEnd[0]);
        }

        if ((zone === 'Zone 1' || !zone) && foundBuildings.length) {
          const firstWithZone = foundBuildings.find((b) => b.zone)?.zone;
          if (firstWithZone) setZone(firstWithZone);
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
  }, [location, serviceType, zone, bEnd, isP2P]);

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
          <div className="flex items-center justify-center mb-2">
            <MapPin className="w-6 h-6 text-primary-600 dark:text-primary-400 mr-2" />
            <h1 className="text-3xl md:text-4xl font-bold text-gray-900 dark:text-white">
              Search Results
            </h1>
          </div>
          {serviceCategory && (
            <span className="inline-block bg-primary-100 dark:bg-primary-900/50 text-primary-700 dark:text-primary-300 text-sm font-semibold px-4 py-1 rounded-full mb-3">
              {SERVICE_LABELS[serviceCategory] || serviceCategory}
            </span>
          )}
          {isP2P ? (
            <div className="flex flex-col sm:flex-row items-center justify-center gap-2 text-base text-gray-600 dark:text-gray-400">
              <span className="font-semibold text-primary-600 dark:text-primary-400">A-End:</span>
              <span>{aEnd}</span>
              <span className="hidden sm:block text-gray-400">→</span>
              <span className="font-semibold text-orange-500">B-End:</span>
              <span>{bEnd}</span>
            </div>
          ) : (
            <p className="text-xl text-gray-600 dark:text-gray-400">
              Location: <span className="font-semibold">{location}</span>
            </p>
          )}
          {reqBandwidth && (
            <p className="text-sm text-gray-500 dark:text-gray-400 mt-1">
              Requested: <span className="font-semibold">{reqBandwidth} Mbps</span>
            </p>
          )}
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

        {error && (
          <div className="max-w-4xl mx-auto mb-6 bg-red-50 border border-red-200 text-red-700 p-4 rounded-lg">
            <AlertCircle className="inline mr-2" size={18} />{error}
          </div>
        )}
        {info && (
          <div className="max-w-4xl mx-auto mb-6 bg-green-50 border border-green-200 text-green-700 p-4 rounded-lg">
            <AlertCircle className="inline mr-2" size={18} />{info}
          </div>
        )}

        {/* Pricing Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 mb-12">
          {loading ? (
            [1, 2, 3].map((n) => <SkeletonCard key={n} />)
          ) : pricingData.length === 0 ? (
            <div className="col-span-3 text-center py-12 text-gray-500 dark:text-gray-400">
              No pricing data available for the selected zone and service type.
            </div>
          ) : (
            pricingData.map((tier) => (
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
                        <div className="flex items-baseline mb-1">
                          <span className="text-3xl font-bold text-primary-600 dark:text-primary-400">
                            {formatUSD(withPPN(tier.basePrice))}
                          </span>
                          <span className="text-gray-600 dark:text-gray-400 ml-2">/month</span>
                        </div>
                        <div className="text-xs text-gray-400 dark:text-gray-500 space-y-0.5">
                          <div>Base price: {formatUSD(tier.basePrice)}</div>
                          <div>VAT 11%: {formatUSD(ppnAmount(tier.basePrice))}</div>
                          <div className="text-gray-300 dark:text-gray-600">Prices in USD</div>
                        </div>
                        <div className="mt-2 text-sm text-gray-500 dark:text-gray-400">
                          OTC: <span className="font-medium">{formatUSD(withPPN(tier.otc))}</span>
                          <span className="text-xs ml-1">(incl. VAT)</span>
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
            ))
          )}
        </div>

        {/* Your Order */}
        {selectedTier && (
          <div className="max-w-4xl mx-auto mb-8 bg-white dark:bg-gray-800 rounded-2xl shadow-lg p-6">
            <div className="flex items-center mb-4">
              <FileText className="w-5 h-5 text-primary-600 dark:text-primary-400 mr-2" />
              <h3 className="text-xl font-bold text-gray-900 dark:text-white">Your Order</h3>
            </div>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm text-gray-700 dark:text-gray-300">
              {serviceCategory && (
                <div className="md:col-span-2"><span className="font-semibold">Service:</span> {SERVICE_LABELS[serviceCategory] || serviceCategory}</div>
              )}
              {isP2P ? (
                <>
                  <div className="flex items-center gap-2">
                    <span><span className="font-semibold">A-End:</span> {aEnd || '-'}</span>
                    {aEnd && (
                      <a
                        href={getMapsUrl(selectedBEndBuilding?.address || aEnd, aEnd)}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="inline-flex items-center gap-1 text-xs text-primary-600 dark:text-primary-400 hover:underline flex-shrink-0"
                        onClick={(e) => e.stopPropagation()}
                      >
                        <ExternalLink className="w-3 h-3" /> Maps
                      </a>
                    )}
                  </div>
                  <div className="flex items-center gap-2">
                    <span><span className="font-semibold">B-End:</span> {bEnd || '-'}</span>
                    {bEnd && (
                      <a
                        href={getMapsUrl(selectedBEndBuilding?.address || bEnd, bEnd)}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="inline-flex items-center gap-1 text-xs text-orange-500 hover:underline flex-shrink-0"
                        onClick={(e) => e.stopPropagation()}
                      >
                        <ExternalLink className="w-3 h-3" /> Maps
                      </a>
                    )}
                  </div>
                </>
              ) : (
                <>
                  <div><span className="font-semibold">Location:</span> {selectedBuilding?.building_name || location || '-'}</div>
                  <div className="flex items-center gap-2">
                    <span><span className="font-semibold">Address:</span> {selectedBuilding?.address || 'N/A'}</span>
                    {selectedBuilding?.address && (
                      <a
                        href={getMapsUrl(selectedBuilding.address, selectedBuilding.building_name)}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="inline-flex items-center gap-1 text-xs text-primary-600 dark:text-primary-400 hover:underline flex-shrink-0"
                        onClick={(e) => e.stopPropagation()}
                      >
                        <ExternalLink className="w-3 h-3" /> Maps
                      </a>
                    )}
                  </div>
                </>
              )}
              <div><span className="font-semibold">Bandwidth:</span> {selectedTier.tier}</div>
              <div><span className="font-semibold">Service Type:</span> {selectedTier.serviceType}</div>
              <div><span className="font-semibold">Zone:</span> {selectedTier.zone}</div>
              <div className="md:col-span-2 border-t border-gray-100 dark:border-gray-700 pt-3 mt-1">
                <p className="text-xs text-gray-400 dark:text-gray-500 mb-2">Prices in USD &bull; VAT 11% included</p>
                <table className="w-full text-sm">
                  <tbody>
                    <tr>
                      <td className="text-gray-500 dark:text-gray-400 py-0.5">MRC (excl. VAT)</td>
                      <td className="text-right font-medium">{formatUSD(selectedTier.basePrice)}</td>
                    </tr>
                    <tr>
                      <td className="text-gray-500 dark:text-gray-400 py-0.5">VAT 11%</td>
                      <td className="text-right">{formatUSD(ppnAmount(selectedTier.basePrice))}</td>
                    </tr>
                    <tr className="font-semibold text-primary-600 dark:text-primary-400">
                      <td className="py-0.5">Total MRC (incl. VAT)</td>
                      <td className="text-right">{formatUSD(withPPN(selectedTier.basePrice))}</td>
                    </tr>
                    <tr className="border-t border-gray-100 dark:border-gray-700">
                      <td className="text-gray-500 dark:text-gray-400 pt-2">OTC (excl. VAT)</td>
                      <td className="text-right pt-2">{formatUSD(selectedTier.otc)}</td>
                    </tr>
                    <tr>
                      <td className="text-gray-500 dark:text-gray-400 py-0.5">VAT 11%</td>
                      <td className="text-right">{formatUSD(ppnAmount(selectedTier.otc))}</td>
                    </tr>
                    <tr className="font-semibold text-primary-600 dark:text-primary-400">
                      <td className="py-0.5">Total OTC (incl. VAT)</td>
                      <td className="text-right">{formatUSD(withPPN(selectedTier.otc))}</td>
                    </tr>
                  </tbody>
                </table>
              </div>
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
            <h3 className="text-xl font-bold text-gray-900 dark:text-white">
              {isP2P ? 'A-End Building Results' : 'Building Results'}
            </h3>
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
                  <div className="flex items-start justify-between gap-2">
                    <div className="min-w-0">
                      <div className="font-semibold text-gray-900 dark:text-white">{b.building_name}</div>
                      <div className="text-sm text-gray-600 dark:text-gray-400">{b.address}</div>
                      <div className="text-xs text-gray-500 dark:text-gray-500">{b.city || 'N/A'} • {b.zone || 'Zone ?'}</div>
                    </div>
                    <a
                      href={getMapsUrl(b.address, b.building_name)}
                      target="_blank"
                      rel="noopener noreferrer"
                      onClick={(e) => e.stopPropagation()}
                      className="flex-shrink-0 inline-flex items-center gap-1 text-xs font-medium text-primary-600 dark:text-primary-400 hover:text-primary-800 dark:hover:text-primary-200 bg-primary-50 dark:bg-primary-900/40 hover:bg-primary-100 dark:hover:bg-primary-900/70 px-2 py-1 rounded-md transition-colors mt-0.5"
                    >
                      <ExternalLink className="w-3 h-3" /> Maps
                    </a>
                  </div>
                </li>
              ))}
            </ul>
          )}
        </div>

        {/* B-End Building results (P2P only) */}
        {isP2P && bEnd && (
          <div className="max-w-5xl mx-auto bg-white dark:bg-gray-800 rounded-2xl shadow-lg p-6 mt-4">
            <div className="flex items-center mb-4">
              <MapPin className="w-5 h-5 text-orange-500 mr-2" />
              <h3 className="text-xl font-bold text-gray-900 dark:text-white">B-End Building Results</h3>
            </div>
            {loading ? (
              <div className="text-gray-500 dark:text-gray-400">Loading data...</div>
            ) : bEndBuildings.length === 0 ? (
              <div className="text-gray-500 dark:text-gray-400">No buildings found for B-End keyword.</div>
            ) : (
              <ul className="divide-y divide-gray-200 dark:divide-gray-700">
                {bEndBuildings.map((b) => (
                  <li
                    key={b.id}
                    onClick={() => setSelectedBEndBuilding(b)}
                    className={`py-3 cursor-pointer ${selectedBEndBuilding?.id === b.id ? 'bg-orange-50 dark:bg-orange-900/30 rounded-lg px-3' : ''}`}
                  >
                    <div className="flex items-start justify-between gap-2">
                      <div className="min-w-0">
                        <div className="font-semibold text-gray-900 dark:text-white">{b.building_name}</div>
                        <div className="text-sm text-gray-600 dark:text-gray-400">{b.address}</div>
                        <div className="text-xs text-gray-500 dark:text-gray-500">{b.city || 'N/A'} • {b.zone || 'Zone ?'}</div>
                      </div>
                      <a
                        href={getMapsUrl(b.address, b.building_name)}
                        target="_blank"
                        rel="noopener noreferrer"
                        onClick={(e) => e.stopPropagation()}
                        className="flex-shrink-0 inline-flex items-center gap-1 text-xs font-medium text-orange-600 dark:text-orange-400 hover:text-orange-800 dark:hover:text-orange-200 bg-orange-50 dark:bg-orange-900/40 hover:bg-orange-100 dark:hover:bg-orange-900/70 px-2 py-1 rounded-md transition-colors mt-0.5"
                      >
                        <ExternalLink className="w-3 h-3" /> Maps
                      </a>
                    </div>
                  </li>
                ))}
              </ul>
            )}
          </div>
        )}
        
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
