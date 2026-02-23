import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Search, Wifi, Globe, Network, Server, Cable, ArrowRight, MapPin } from 'lucide-react';

const SERVICES = [
  {
    id: 'dia',
    label: 'Dedicated Internet Access',
    short: 'DIA',
    icon: Globe,
    description: 'Guaranteed bandwidth with SLA for critical business operations.',
    type: 'single', // single address
    bandwidthLabel: 'Bandwidth (Mbps)',
  },
  {
    id: 'broadband',
    label: 'Broadband Internet',
    short: 'Broadband',
    icon: Wifi,
    description: 'High-speed shared internet access for offices and branches.',
    type: 'single',
    bandwidthLabel: 'Bandwidth (Mbps)',
  },
  {
    id: 'metronet',
    label: 'Metro Ethernet Local Loop',
    short: 'Metro Ethernet',
    icon: Network,
    description: 'Point-to-point Ethernet connectivity within metro area.',
    type: 'p2p', // A-End & B-End
    bandwidthLabel: 'Bandwidth (Mbps)',
  },
  {
    id: 'dc2dc',
    label: 'DC to DC Interconnection',
    short: 'DC-DC',
    icon: Server,
    description: 'Dedicated interconnection between two data centers.',
    type: 'p2p',
    bandwidthLabel: 'Bandwidth (Mbps)',
  },
  {
    id: 'darkfiber',
    label: 'Dark Fiber',
    short: 'Dark Fiber',
    icon: Cable,
    description: 'Unlit fiber optic infrastructure for your own wavelength.',
    type: 'p2p',
    bandwidthLabel: 'Core Count',
  },
];

const Home = () => {
  const [selectedService, setSelectedService] = useState(null);
  const [location, setLocation] = useState('');
  const [aEnd, setAEnd] = useState('');
  const [bEnd, setBEnd] = useState('');
  const [bandwidth, setBandwidth] = useState('');
  const navigate = useNavigate();

  const service = SERVICES.find((s) => s.id === selectedService);

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!service) return;

    if (service.type === 'single') {
      if (!location.trim()) return;
      const params = new URLSearchParams({
        location: location.trim(),
        serviceCategory: service.id,
      });
      if (bandwidth.trim()) params.set('bandwidth', bandwidth.trim());
      navigate(`/results?${params.toString()}`);
    } else {
      if (!aEnd.trim() || !bEnd.trim()) return;
      const params = new URLSearchParams({
        location: aEnd.trim(),
        aEnd: aEnd.trim(),
        bEnd: bEnd.trim(),
        serviceCategory: service.id,
      });
      if (bandwidth.trim()) params.set('bandwidth', bandwidth.trim());
      navigate(`/results?${params.toString()}`);
    }
  };

  return (
    <div className="min-h-screen">
      {/* Hero Section */}
      <section className="relative bg-gradient-to-br from-primary-600 to-primary-800 dark:from-primary-800 dark:to-primary-900 text-white py-16 md:py-24">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center max-w-4xl mx-auto">
            <p className="text-sm md:text-base font-semibold uppercase tracking-widest text-primary-200 mb-3">
              Netpoint Indonesia
            </p>
            <h1 className="text-4xl md:text-5xl lg:text-6xl font-bold mb-4 animate-fade-in leading-tight">
              Gateway to Connect Your Businesses to Indonesia
            </h1>
            <p className="text-lg md:text-xl text-primary-100 mb-10">
              Select a service below and get an instant quote from the Netpoint network.
            </p>

            {/* Service Cards */}
            <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-3 mb-10">
              {SERVICES.map((svc) => {
                const Icon = svc.icon;
                const isActive = selectedService === svc.id;
                return (
                  <button
                    key={svc.id}
                    type="button"
                    onClick={() => {
                      setSelectedService(svc.id);
                      setLocation(''); setAEnd(''); setBEnd(''); setBandwidth('');
                    }}
                    className={`flex flex-col items-center gap-2 p-4 rounded-2xl border-2 transition-all text-sm font-semibold cursor-pointer
                      ${isActive
                        ? 'bg-white text-primary-700 border-white shadow-xl scale-105'
                        : 'bg-white/10 text-white border-white/20 hover:bg-white/20 hover:border-white/50'
                      }`}
                  >
                    <Icon className="w-7 h-7" />
                    <span className="leading-tight text-center">{svc.short}</span>
                  </button>
                );
              })}
            </div>

            {/* Dynamic Form */}
            {service && (
              <div className="bg-white/10 backdrop-blur-sm border border-white/20 rounded-2xl p-6 max-w-2xl mx-auto">
                <p className="text-primary-100 text-sm mb-4 font-medium">{service.description}</p>
                <form onSubmit={handleSubmit} className="space-y-3">
                  {service.type === 'single' ? (
                    <div className="relative">
                      <MapPin className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
                      <input
                        type="text"
                        value={location}
                        onChange={(e) => setLocation(e.target.value)}
                        placeholder="Building Name / Address"
                        required
                        className="w-full pl-12 pr-4 py-3 rounded-xl text-gray-900 dark:text-white bg-white dark:bg-gray-800 focus:outline-none focus:ring-4 focus:ring-primary-300 dark:focus:ring-primary-600"
                      />
                    </div>
                  ) : (
                    <>
                      <div className="relative">
                        <MapPin className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-primary-400" />
                        <input
                          type="text"
                          value={aEnd}
                          onChange={(e) => setAEnd(e.target.value)}
                          placeholder="A-End Address / Building"
                          required
                          className="w-full pl-12 pr-4 py-3 rounded-xl text-gray-900 dark:text-white bg-white dark:bg-gray-800 focus:outline-none focus:ring-4 focus:ring-primary-300 dark:focus:ring-primary-600"
                        />
                      </div>
                      <div className="relative">
                        <MapPin className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-orange-400" />
                        <input
                          type="text"
                          value={bEnd}
                          onChange={(e) => setBEnd(e.target.value)}
                          placeholder="B-End Address / Building"
                          required
                          className="w-full pl-12 pr-4 py-3 rounded-xl text-gray-900 dark:text-white bg-white dark:bg-gray-800 focus:outline-none focus:ring-4 focus:ring-primary-300 dark:focus:ring-primary-600"
                        />
                      </div>
                    </>
                  )}

                  {/* Bandwidth / Core */}
                  <input
                    type="text"
                    value={bandwidth}
                    onChange={(e) => setBandwidth(e.target.value)}
                    placeholder={`${service.bandwidthLabel} (optional)`}
                    className="w-full px-4 py-3 rounded-xl text-gray-900 dark:text-white bg-white dark:bg-gray-800 focus:outline-none focus:ring-4 focus:ring-primary-300 dark:focus:ring-primary-600"
                  />

                  <button
                    type="submit"
                    className="w-full bg-primary-600 hover:bg-primary-700 text-white py-3 rounded-xl font-bold text-base transition-all hover:shadow-lg flex items-center justify-center gap-2"
                  >
                    <Search className="w-5 h-5" />
                    Get Quote
                    <ArrowRight className="w-5 h-5" />
                  </button>
                </form>
              </div>
            )}

            {!service && (
              <p className="text-primary-200 text-sm mt-2">
                Select a service above to get started.
              </p>
            )}
          </div>
        </div>
      </section>

      {/* Services Overview */}
      <section className="py-16 bg-white dark:bg-gray-900">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <h2 className="text-3xl font-bold text-center text-gray-900 dark:text-white mb-10">
            Our Services
          </h2>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {SERVICES.map((svc) => {
              const Icon = svc.icon;
              return (
                <div
                  key={svc.id}
                  onClick={() => {
                    setSelectedService(svc.id);
                    window.scrollTo({ top: 0, behavior: 'smooth' });
                  }}
                  className="flex items-start gap-4 p-6 rounded-2xl bg-gray-50 dark:bg-gray-800 hover:bg-primary-50 dark:hover:bg-primary-900/30 cursor-pointer transition-colors group border border-transparent hover:border-primary-200 dark:hover:border-primary-700"
                >
                  <div className="w-12 h-12 rounded-xl bg-primary-100 dark:bg-primary-900/50 flex items-center justify-center flex-shrink-0 group-hover:bg-primary-200 dark:group-hover:bg-primary-800 transition-colors">
                    <Icon className="w-6 h-6 text-primary-600 dark:text-primary-400" />
                  </div>
                  <div>
                    <h3 className="font-semibold text-gray-900 dark:text-white mb-1">{svc.label}</h3>
                    <p className="text-sm text-gray-500 dark:text-gray-400">{svc.description}</p>
                    <span className="inline-flex items-center gap-1 text-xs text-primary-600 dark:text-primary-400 mt-2 font-medium">
                      Get Quote <ArrowRight className="w-3 h-3" />
                    </span>
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-16 bg-gradient-to-r from-primary-600 to-primary-700 dark:from-primary-700 dark:to-primary-800">
        <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h2 className="text-3xl md:text-4xl font-bold text-white mb-4">
            Ready to Connect with Netpoint?
          </h2>
          <p className="text-xl text-primary-100 mb-8">
            Start your location search now and get the best offer tailored for your business.
          </p>
          <button
            onClick={() => window.scrollTo({ top: 0, behavior: 'smooth' })}
            className="bg-white text-primary-600 hover:bg-gray-100 px-8 py-4 rounded-full font-bold text-lg transition-all hover:shadow-2xl"
          >
            Choose Your Service
          </button>
        </div>
      </section>
    </div>
  );
};

export default Home;
