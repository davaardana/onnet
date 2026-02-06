import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import { 
  Users, Package, DollarSign, TrendingUp, 
  Clock, CheckCircle, XCircle,
  AlertCircle, FileText, UserCheck
} from 'lucide-react';

const AdminDashboard = () => {
  const { user, token } = useAuth();
  const navigate = useNavigate();
  const [stats, setStats] = useState(null);
  const [loading, setLoading] = useState(true);
  const [activeTab, setActiveTab] = useState('overview');
  const [datasets, setDatasets] = useState(null);
  const [savingStatusId, setSavingStatusId] = useState(null);
  const [buildingSearch, setBuildingSearch] = useState('');
  const [buildingPage, setBuildingPage] = useState(1);
  const buildingsPerPage = 50;

  useEffect(() => {
    // Check if user is admin
    if (!user || user.role !== 'admin') {
      navigate('/');
      return;
    }

    fetchStats();
  }, [user, navigate]);

  const fetchStats = async () => {
    try {
      const apiUrl = import.meta.env.VITE_API_URL || '/api';
      const response = await fetch(`${apiUrl}/admin/stats`, {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      });

      if (response.ok) {
        const data = await response.json();
        setStats(data);
        if (activeTab === 'data') {
          await fetchDatasets();
        }
      }
    } catch (error) {
      console.error('Error fetching stats:', error);
    } finally {
      setLoading(false);
    }
  };

  const fetchDatasets = async () => {
    try {
      const apiUrl = import.meta.env.VITE_API_URL || '/api';
      const offset = (buildingPage - 1) * buildingsPerPage;
      const query = new URLSearchParams({
        limit: buildingsPerPage.toString(),
        offset: offset.toString(),
        q: buildingSearch
      });

      const response = await fetch(`${apiUrl}/admin/datasets?${query.toString()}`, {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      });
      if (!response.ok) return;
      const data = await response.json();
      setDatasets(data);
    } catch (err) {
      console.error('Error fetching datasets:', err);
    }
  };

  const updateOrderStatus = async (orderId, status) => {
    try {
      setSavingStatusId(orderId);
      const apiUrl = import.meta.env.VITE_API_URL || '/api';
      const response = await fetch(`${apiUrl}/admin/orders/${orderId}/status`, {
        method: 'PUT',
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ status })
      });

      if (!response.ok) {
        console.error('Failed to update order status');
      } else {
        await fetchStats();
      }
    } catch (err) {
      console.error('Error updating status', err);
    } finally {
      setSavingStatusId(null);
    }
  };

  const formatCurrency = (amount) => {
    return new Intl.NumberFormat('id-ID', {
      style: 'currency',
      currency: 'IDR',
      minimumFractionDigits: 0
    }).format(amount);
  };

  const formatDate = (dateString) => {
    return new Date(dateString).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  };

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-50 dark:bg-gray-900">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600 mx-auto"></div>
          <p className="mt-4 text-gray-600 dark:text-gray-400">Loading dashboard...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900 py-8">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900 dark:text-white">
            Admin Dashboard
          </h1>
          <p className="mt-2 text-gray-600 dark:text-gray-400">
            Welcome back, {user?.name}
          </p>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
          {/* Total Users */}
          <div className="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600 dark:text-gray-400">Total Users</p>
                <p className="text-3xl font-bold text-gray-900 dark:text-white mt-2">
                  {stats?.totalUsers || 0}
                </p>
              </div>
              <div className="bg-blue-100 dark:bg-blue-900 p-3 rounded-lg">
                <Users className="w-6 h-6 text-blue-600 dark:text-blue-400" />
              </div>
            </div>
          </div>

          {/* External Users */}
          <div className="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600 dark:text-gray-400">External Users</p>
                <p className="text-3xl font-bold text-gray-900 dark:text-white mt-2">
                  {stats?.totalExternalUsers || 0}
                </p>
              </div>
              <div className="bg-emerald-100 dark:bg-emerald-900 p-3 rounded-lg">
                <UserCheck className="w-6 h-6 text-emerald-600 dark:text-emerald-400" />
              </div>
            </div>
          </div>

          {/* Total Orders */}
          <div className="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600 dark:text-gray-400">Total Orders</p>
                <p className="text-3xl font-bold text-gray-900 dark:text-white mt-2">
                  {stats?.totalOrders || 0}
                </p>
              </div>
              <div className="bg-green-100 dark:bg-green-900 p-3 rounded-lg">
                <Package className="w-6 h-6 text-green-600 dark:text-green-400" />
              </div>
            </div>
          </div>

          {/* Total Revenue */}
          <div className="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600 dark:text-gray-400">Total Revenue</p>
                <p className="text-2xl font-bold text-gray-900 dark:text-white mt-2">
                  {formatCurrency(stats?.totalRevenue || 0)}
                </p>
              </div>
              <div className="bg-purple-100 dark:bg-purple-900 p-3 rounded-lg">
                <DollarSign className="w-6 h-6 text-purple-600 dark:text-purple-400" />
              </div>
            </div>
          </div>

          {/* Completed Orders */}
          <div className="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600 dark:text-gray-400">Completed</p>
                <p className="text-3xl font-bold text-gray-900 dark:text-white mt-2">
                  {stats?.ordersByStatus?.completed || 0}
                </p>
              </div>
              <div className="bg-emerald-100 dark:bg-emerald-900 p-3 rounded-lg">
                <CheckCircle className="w-6 h-6 text-emerald-600 dark:text-emerald-400" />
              </div>
            </div>
          </div>

          {/* Quote Logs */}
          <div className="bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600 dark:text-gray-400">Quote Logs</p>
                <p className="text-3xl font-bold text-gray-900 dark:text-white mt-2">
                  {stats?.quoteLogs?.length || 0}
                </p>
              </div>
              <div className="bg-amber-100 dark:bg-amber-900 p-3 rounded-lg">
                <FileText className="w-6 h-6 text-amber-600 dark:text-amber-400" />
              </div>
            </div>
          </div>
        </div>

        {/* Tabs */}
        <div className="bg-white dark:bg-gray-800 rounded-xl shadow-lg mb-8">
          <div className="border-b border-gray-200 dark:border-gray-700">
            <nav className="flex -mb-px">
              <button
                onClick={() => setActiveTab('overview')}
                className={`px-6 py-4 text-sm font-medium border-b-2 ${
                  activeTab === 'overview'
                    ? 'border-primary-600 text-primary-600 dark:text-primary-400'
                    : 'border-transparent text-gray-600 dark:text-gray-400 hover:text-gray-800 dark:hover:text-gray-200'
                }`}
              >
                Overview
              </button>
              <button
                onClick={() => setActiveTab('orders')}
                className={`px-6 py-4 text-sm font-medium border-b-2 ${
                  activeTab === 'orders'
                    ? 'border-primary-600 text-primary-600 dark:text-primary-400'
                    : 'border-transparent text-gray-600 dark:text-gray-400 hover:text-gray-800 dark:hover:text-gray-200'
                }`}
              >
                Recent Orders
              </button>
              <button
                onClick={() => setActiveTab('locations')}
                className={`px-6 py-4 text-sm font-medium border-b-2 ${
                  activeTab === 'locations'
                    ? 'border-primary-600 text-primary-600 dark:text-primary-400'
                    : 'border-transparent text-gray-600 dark:text-gray-400 hover:text-gray-800 dark:hover:text-gray-200'
                }`}
              >
                Top Locations
              </button>
              <button
                onClick={() => {
                  setActiveTab('data');
                  fetchDatasets();
                }}
                className={`px-6 py-4 text-sm font-medium border-b-2 ${
                  activeTab === 'data'
                    ? 'border-primary-600 text-primary-600 dark:text-primary-400'
                    : 'border-transparent text-gray-600 dark:text-gray-400 hover:text-gray-800 dark:hover:text-gray-200'
                }`}
              >
                Data Explorer
              </button>
            </nav>
          </div>

          <div className="p-6">
            {/* Overview Tab */}
            {activeTab === 'overview' && (
              <div className="space-y-6">
                <h3 className="text-lg font-semibold text-gray-900 dark:text-white">
                  Orders by Status
                </h3>
                <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                  <div className="bg-yellow-50 dark:bg-yellow-900/20 rounded-lg p-4">
                    <div className="flex items-center space-x-2">
                      <Clock className="w-5 h-5 text-yellow-600 dark:text-yellow-400" />
                      <span className="text-sm text-gray-600 dark:text-gray-400">Pending</span>
                    </div>
                    <p className="text-2xl font-bold text-gray-900 dark:text-white mt-2">
                      {stats?.ordersByStatus?.pending || 0}
                    </p>
                  </div>
                  <div className="bg-blue-50 dark:bg-blue-900/20 rounded-lg p-4">
                    <div className="flex items-center space-x-2">
                      <TrendingUp className="w-5 h-5 text-blue-600 dark:text-blue-400" />
                      <span className="text-sm text-gray-600 dark:text-gray-400">Processing</span>
                    </div>
                    <p className="text-2xl font-bold text-gray-900 dark:text-white mt-2">
                      {stats?.ordersByStatus?.processing || 0}
                    </p>
                  </div>
                  <div className="bg-green-50 dark:bg-green-900/20 rounded-lg p-4">
                    <div className="flex items-center space-x-2">
                      <CheckCircle className="w-5 h-5 text-green-600 dark:text-green-400" />
                      <span className="text-sm text-gray-600 dark:text-gray-400">Completed</span>
                    </div>
                    <p className="text-2xl font-bold text-gray-900 dark:text-white mt-2">
                      {stats?.ordersByStatus?.completed || 0}
                    </p>
                  </div>
                  <div className="bg-red-50 dark:bg-red-900/20 rounded-lg p-4">
                    <div className="flex items-center space-x-2">
                      <XCircle className="w-5 h-5 text-red-600 dark:text-red-400" />
                      <span className="text-sm text-gray-600 dark:text-gray-400">Cancelled</span>
                    </div>
                    <p className="text-2xl font-bold text-gray-900 dark:text-white mt-2">
                      {stats?.ordersByStatus?.cancelled || 0}
                    </p>
                  </div>
                </div>
              </div>
            )}

            {/* Recent Orders Tab */}
            {activeTab === 'orders' && (
              <div>
                <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">
                  Recent Orders
                </h3>
                <div className="overflow-x-auto">
                  <table className="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
                    <thead className="bg-gray-50 dark:bg-gray-900">
                      <tr>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                          Order #
                        </th>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                          Customer
                        </th>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                          Location
                        </th>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                          Package
                        </th>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                          Price
                        </th>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                          Status
                        </th>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                          Date
                        </th>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                          Actions
                        </th>
                      </tr>
                    </thead>
                    <tbody className="bg-white dark:bg-gray-800 divide-y divide-gray-200 dark:divide-gray-700">
                      {stats?.recentOrders?.map((order) => (
                        <tr key={order.id}>
                          <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900 dark:text-white">
                            #{order.id}
                          </td>
                          <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600 dark:text-gray-400">
                            {order.user_name}
                          </td>
                          <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600 dark:text-gray-400">
                            {order.location_name}
                          </td>
                          <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600 dark:text-gray-400">
                            {order.tier_name || `${order.bandwidth_mbps || '-'} Mbps ${order.service_type || ''}`}
                          </td>
                          <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600 dark:text-gray-400">
                            {order.monthly_price ? formatCurrency(order.monthly_price) : '-'}
                          </td>
                          <td className="px-6 py-4 whitespace-nowrap">
                            <span className={`px-2 py-1 inline-flex text-xs leading-5 font-semibold rounded-full ${
                              order.status === 'completed' 
                                ? 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200'
                                : order.status === 'processing'
                                ? 'bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-200'
                                : order.status === 'cancelled'
                                ? 'bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-200'
                                : 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-200'
                            }`}>
                              {order.status}
                            </span>
                          </td>
                          <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600 dark:text-gray-400">
                            {formatDate(order.created_at)}
                          </td>
                          <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600 dark:text-gray-400 space-x-2">
                            <button
                              onClick={() => updateOrderStatus(order.id, 'completed')}
                              disabled={savingStatusId === order.id}
                              className="px-3 py-1 bg-emerald-600 text-white rounded hover:bg-emerald-700 disabled:opacity-50"
                            >
                              Done
                            </button>
                            <button
                              onClick={() => updateOrderStatus(order.id, 'cancelled')}
                              disabled={savingStatusId === order.id}
                              className="px-3 py-1 bg-red-600 text-white rounded hover:bg-red-700 disabled:opacity-50"
                            >
                              Delete
                            </button>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </div>
            )}

            {/* Top Locations Tab */}
            {activeTab === 'locations' && (
              <div>
                <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">
                  Top Locations
                </h3>
                <div className="space-y-4">
                  {stats?.topLocations?.map((location, index) => (
                    <div key={index} className="flex items-center justify-between p-4 bg-gray-50 dark:bg-gray-900 rounded-lg">
                      <div className="flex items-center space-x-4">
                        <div className="bg-primary-100 dark:bg-primary-900 p-2 rounded-lg">
                          <MapPin className="w-5 h-5 text-primary-600 dark:text-primary-400" />
                        </div>
                        <div>
                          <p className="font-semibold text-gray-900 dark:text-white">
                            {location.name}
                          </p>
                          <p className="text-sm text-gray-600 dark:text-gray-400">
                            {location.city}
                          </p>
                        </div>
                      </div>
                      <div className="text-right">
                        <p className="text-2xl font-bold text-gray-900 dark:text-white">
                          {location.order_count}
                        </p>
                        <p className="text-sm text-gray-600 dark:text-gray-400">
                          orders
                        </p>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            )}

            {/* Data Explorer Tab */}
            {activeTab === 'data' && (
              <div className="space-y-8">
                <div>
                  <div className="flex items-center justify-between mb-2">
                    <h3 className="text-lg font-semibold text-gray-900 dark:text-white">Price List (active)</h3>
                    <span className="text-sm text-gray-500">{datasets?.priceList?.length || 0} rows</span>
                  </div>
                  <div className="overflow-x-auto rounded-lg border border-gray-200 dark:border-gray-700">
                    <table className="min-w-full text-sm">
                      <thead className="bg-gray-50 dark:bg-gray-900 text-gray-600 dark:text-gray-400">
                        <tr>
                          <th className="px-3 py-2 text-left">BW</th>
                          <th className="px-3 py-2 text-left">Dom OTC</th>
                          <th className="px-3 py-2 text-left">Dom Z1</th>
                          <th className="px-3 py-2 text-left">Dom Z2</th>
                          <th className="px-3 py-2 text-left">Dom Z3</th>
                          <th className="px-3 py-2 text-left">Dom Z4</th>
                          <th className="px-3 py-2 text-left">Intl OTC</th>
                          <th className="px-3 py-2 text-left">Intl Z1</th>
                          <th className="px-3 py-2 text-left">Intl Z2</th>
                          <th className="px-3 py-2 text-left">Intl Z3</th>
                          <th className="px-3 py-2 text-left">Intl Z4</th>
                          <th className="px-3 py-2 text-left">DIA OTC</th>
                          <th className="px-3 py-2 text-left">DIA MRC</th>
                          <th className="px-3 py-2 text-left">IDIA OTC</th>
                          <th className="px-3 py-2 text-left">IDIA MRC</th>
                        </tr>
                      </thead>
                      <tbody className="divide-y divide-gray-200 dark:divide-gray-700">
                        {datasets?.priceList?.map((p) => (
                          <tr key={p.id}>
                            <td className="px-3 py-2 text-gray-900 dark:text-white">{p.bandwidth_mbps} Mbps</td>
                            <td className="px-3 py-2">{formatCurrency(p.domestic_otc)}</td>
                            <td className="px-3 py-2">{formatCurrency(p.domestic_mrc_zone1)}</td>
                            <td className="px-3 py-2">{formatCurrency(p.domestic_mrc_zone2)}</td>
                            <td className="px-3 py-2">{formatCurrency(p.domestic_mrc_zone3)}</td>
                            <td className="px-3 py-2">{formatCurrency(p.domestic_mrc_zone4)}</td>
                            <td className="px-3 py-2">{formatCurrency(p.intl_otc)}</td>
                            <td className="px-3 py-2">{formatCurrency(p.intl_mrc_zone1)}</td>
                            <td className="px-3 py-2">{formatCurrency(p.intl_mrc_zone2)}</td>
                            <td className="px-3 py-2">{formatCurrency(p.intl_mrc_zone3)}</td>
                            <td className="px-3 py-2">{formatCurrency(p.intl_mrc_zone4)}</td>
                            <td className="px-3 py-2">{formatCurrency(p.dia_otc)}</td>
                            <td className="px-3 py-2">{formatCurrency(p.dia_mrc)}</td>
                            <td className="px-3 py-2">{formatCurrency(p.idia_otc)}</td>
                            <td className="px-3 py-2">{formatCurrency(p.idia_mrc)}</td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                </div>

                <div>
                  <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-3 mb-2">
                    <div>
                      <h3 className="text-lg font-semibold text-gray-900 dark:text-white">Buildings</h3>
                      <span className="text-sm text-gray-500">{datasets?.buildingsTotal || 0} total</span>
                    </div>
                    <div className="flex gap-2">
                      <input
                        value={buildingSearch}
                        onChange={(e) => setBuildingSearch(e.target.value)}
                        placeholder="Search name/address/city/zone..."
                        className="px-3 py-2 border border-gray-300 rounded-lg text-sm dark:bg-gray-900 dark:border-gray-700 dark:text-white"
                      />
                      <button
                        onClick={() => {
                          setBuildingPage(1);
                          fetchDatasets();
                        }}
                        className="px-4 py-2 bg-primary-600 text-white rounded-lg text-sm"
                      >
                        Search
                      </button>
                    </div>
                  </div>
                  <div className="overflow-x-auto rounded-lg border border-gray-200 dark:border-gray-700">
                    <table className="min-w-full text-sm">
                      <thead className="bg-gray-50 dark:bg-gray-900 text-gray-600 dark:text-gray-400">
                        <tr>
                          <th className="px-3 py-2 text-left">No</th>
                          <th className="px-3 py-2 text-left">Name</th>
                          <th className="px-3 py-2 text-left">Address</th>
                          <th className="px-3 py-2 text-left">City</th>
                          <th className="px-3 py-2 text-left">Zone</th>
                          <th className="px-3 py-2 text-left">Status</th>
                        </tr>
                      </thead>
                      <tbody className="divide-y divide-gray-200 dark:divide-gray-700">
                        {datasets?.buildings?.map((b, idx) => (
                          <tr key={b.id}>
                            <td className="px-3 py-2 text-gray-500">
                              {(buildingPage - 1) * buildingsPerPage + idx + 1}
                            </td>
                            <td className="px-3 py-2 text-gray-900 dark:text-white">{b.building_name}</td>
                            <td className="px-3 py-2">{b.address || '-'}</td>
                            <td className="px-3 py-2">{b.city || '-'}</td>
                            <td className="px-3 py-2">{b.zone || '-'}</td>
                            <td className="px-3 py-2">{b.status}</td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                  <div className="flex items-center justify-between mt-3 text-sm text-gray-600 dark:text-gray-400">
                    <div>
                      Showing {datasets?.buildings?.length || 0} of {datasets?.buildingsTotal || 0}
                    </div>
                    <div className="flex gap-2">
                      <button
                        onClick={() => {
                          if (buildingPage > 1) {
                            setBuildingPage(buildingPage - 1);
                            fetchDatasets();
                          }
                        }}
                        className="px-3 py-1 border rounded"
                      >
                        Prev
                      </button>
                      <span>Page {buildingPage}</span>
                      <button
                        onClick={() => {
                          const maxPage = Math.ceil((datasets?.buildingsTotal || 0) / buildingsPerPage);
                          if (buildingPage < maxPage) {
                            setBuildingPage(buildingPage + 1);
                            fetchDatasets();
                          }
                        }}
                        className="px-3 py-1 border rounded"
                      >
                        Next
                      </button>
                    </div>
                  </div>
                </div>

                <div>
                  <div className="flex items-center justify-between mb-2">
                    <h3 className="text-lg font-semibold text-gray-900 dark:text-white">Quote Logs</h3>
                    <span className="text-sm text-gray-500">{datasets?.quoteLogs?.length || stats?.quoteLogs?.length || 0} rows</span>
                  </div>
                  <div className="overflow-x-auto rounded-lg border border-gray-200 dark:border-gray-700">
                    <table className="min-w-full text-sm">
                      <thead className="bg-gray-50 dark:bg-gray-900 text-gray-600 dark:text-gray-400">
                        <tr>
                          <th className="px-3 py-2 text-left">User</th>
                          <th className="px-3 py-2 text-left">BW</th>
                          <th className="px-3 py-2 text-left">Service</th>
                          <th className="px-3 py-2 text-left">Zone</th>
                          <th className="px-3 py-2 text-left">Source</th>
                          <th className="px-3 py-2 text-left">OTC</th>
                          <th className="px-3 py-2 text-left">MRC</th>
                        </tr>
                      </thead>
                      <tbody className="divide-y divide-gray-200 dark:divide-gray-700">
                        {(datasets?.quoteLogs || stats?.quoteLogs || []).map((q) => (
                          <tr key={q.id}>
                            <td className="px-3 py-2 text-gray-900 dark:text-white">{q.user_email || q.user_name || '-'}</td>
                            <td className="px-3 py-2">{q.bandwidth_mbps} Mbps</td>
                            <td className="px-3 py-2">{q.service_type}</td>
                            <td className="px-3 py-2">{q.zone}</td>
                            <td className="px-3 py-2">{q.source}</td>
                            <td className="px-3 py-2">{formatCurrency(q.otc)}</td>
                            <td className="px-3 py-2">{formatCurrency(q.mrc)}</td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                </div>

                <div>
                  <div className="flex items-center justify-between mb-2">
                    <h3 className="text-lg font-semibold text-gray-900 dark:text-white">External Users</h3>
                    <span className="text-sm text-gray-500">{datasets?.usersExternal?.length || 0} rows</span>
                  </div>
                  <div className="overflow-x-auto rounded-lg border border-gray-200 dark:border-gray-700">
                    <table className="min-w-full text-sm">
                      <thead className="bg-gray-50 dark:bg-gray-900 text-gray-600 dark:text-gray-400">
                        <tr>
                          <th className="px-3 py-2 text-left">Name</th>
                          <th className="px-3 py-2 text-left">Email</th>
                          <th className="px-3 py-2 text-left">Phone</th>
                          <th className="px-3 py-2 text-left">Created</th>
                        </tr>
                      </thead>
                      <tbody className="divide-y divide-gray-200 dark:divide-gray-700">
                        {datasets?.usersExternal?.map((u) => (
                          <tr key={u.id}>
                            <td className="px-3 py-2 text-gray-900 dark:text-white">{u.name}</td>
                            <td className="px-3 py-2">{u.email}</td>
                            <td className="px-3 py-2">{u.phone || '-'}</td>
                            <td className="px-3 py-2">{formatDate(u.created_at)}</td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default AdminDashboard;
