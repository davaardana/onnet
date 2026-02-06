import React from 'react';
import { Network, Mail, Phone, MapPin } from 'lucide-react';

const Footer = () => {
  return (
    <footer className="bg-gray-100 dark:bg-gray-800 border-t border-gray-200 dark:border-gray-700 mt-auto">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          {/* Brand */}
          <div>
            <div className="flex items-center space-x-2 mb-4">
              <Network className="w-8 h-8 text-primary-600 dark:text-primary-400" />
              <span className="text-2xl font-bold text-gray-900 dark:text-white">
                Netpoint
              </span>
            </div>
            <p className="text-gray-600 dark:text-gray-400 text-sm">
              Connect Your Business Anywhere. Integrated network solutions for your business with access to nationwide providers.
            </p>
          </div>

          {/* Quick Links */}
          <div>
            <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">
              Quick Links
            </h3>
            <ul className="space-y-2">
              <li>
                <a href="/" className="text-gray-600 dark:text-gray-400 hover:text-primary-600 dark:hover:text-primary-400 text-sm">
                  Home
                </a>
              </li>
              <li>
                <a href="/search" className="text-gray-600 dark:text-gray-400 hover:text-primary-600 dark:hover:text-primary-400 text-sm">
                  Search Location
                </a>
              </li>
              <li>
                <a href="#" className="text-gray-600 dark:text-gray-400 hover:text-primary-600 dark:hover:text-primary-400 text-sm">
                  About Us
                </a>
              </li>
              <li>
                <a href="#" className="text-gray-600 dark:text-gray-400 hover:text-primary-600 dark:hover:text-primary-400 text-sm">
                  Services
                </a>
              </li>
            </ul>
          </div>

          {/* Contact */}
          <div>
            <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">
              Contact Us
            </h3>
            <ul className="space-y-3">
              <li className="flex items-start space-x-3">
                <MapPin className="w-5 h-5 text-primary-600 dark:text-primary-400 mt-0.5" />
                <span className="text-gray-600 dark:text-gray-400 text-sm">
                  Jakarta, Indonesia
                </span>
              </li>
              <li className="flex items-start space-x-3">
                <Mail className="w-5 h-5 text-primary-600 dark:text-primary-400 mt-0.5" />
                <span className="text-gray-600 dark:text-gray-400 text-sm">
                  info@netpoint.co.id
                </span>
              </li>
              <li className="flex items-start space-x-3">
                <Phone className="w-5 h-5 text-primary-600 dark:text-primary-400 mt-0.5" />
                <span className="text-gray-600 dark:text-gray-400 text-sm">
                  +62 21 1234 5678
                </span>
              </li>
            </ul>
          </div>
        </div>

        <div className="border-t border-gray-200 dark:border-gray-700 mt-8 pt-8 text-center">
          <p className="text-gray-600 dark:text-gray-400 text-sm">
            © {new Date().getFullYear()} Netpoint. All rights reserved.
          </p>
        </div>
      </div>
    </footer>
  );
};

export default Footer;
