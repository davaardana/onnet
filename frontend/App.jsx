import React, { Suspense, lazy } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { ThemeProvider } from './contexts/ThemeContext';
import { AuthProvider, useAuth } from './contexts/AuthContext';
import { ToastProvider } from './contexts/ToastContext';
import Navbar from './components/Navbar';
import Footer from './components/Footer';

// Code-split pages with React.lazy
const Home = lazy(() => import('./pages/Home'));
const Login = lazy(() => import('./pages/Login'));
const Register = lazy(() => import('./pages/Register'));
const Results = lazy(() => import('./pages/Results'));
const AdminDashboard = lazy(() => import('./pages/AdminDashboard'));
const Pricing = lazy(() => import('./pages/Pricing'));
const AuthCallback = lazy(() => import('./pages/AuthCallback'));

// Elegant loading state during code chunk fetches
const PageLoader = () => (
  <div className="min-h-[60vh] flex flex-col items-center justify-center px-4">
    <div className="relative w-12 h-12">
      <div className="w-12 h-12 rounded-full border-4 border-primary-200 dark:border-primary-900"></div>
      <div className="w-12 h-12 rounded-full border-4 border-primary-600 dark:border-primary-400 border-t-transparent animate-spin absolute top-0 left-0"></div>
    </div>
    <span className="mt-4 text-sm font-medium text-gray-500 dark:text-gray-400">
      Loading page...
    </span>
  </div>
);

// ProtectedRoute: redirects to /login if not authenticated, or to / if wrong role
const ProtectedRoute = ({ children, role }) => {
  const { isAuthenticated, user } = useAuth();
  if (!isAuthenticated) return <Navigate to="/login" replace />;
  if (role && user?.role !== role) return <Navigate to="/" replace />;
  return children;
};

const NotFound = () => (
  <div className="min-h-screen flex items-center justify-center bg-gray-50 dark:bg-gray-900">
    <div className="text-center px-4">
      <h1 className="text-6xl font-bold text-gray-300 dark:text-gray-700 mb-4">404</h1>
      <h2 className="text-2xl font-bold text-gray-900 dark:text-white mb-2">Page Not Found</h2>
      <p className="text-gray-600 dark:text-gray-400 mb-6">The page you are looking for does not exist.</p>
      <a href="/" className="bg-primary-600 hover:bg-primary-700 text-white px-6 py-3 rounded-lg inline-block transition-colors shadow-sm">
        Back to Home
      </a>
    </div>
  </div>
);

class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false, error: null };
  }
  static getDerivedStateFromError(error) {
    return { hasError: true, error };
  }
  componentDidCatch(error, info) {
    console.error('ErrorBoundary caught:', error, info);
  }
  render() {
    if (this.state.hasError) {
      return (
        <div className="min-h-screen flex items-center justify-center bg-gray-50 dark:bg-gray-900 px-4">
          <div className="text-center max-w-md">
            <h1 className="text-4xl font-bold text-gray-900 dark:text-white mb-4">Something went wrong</h1>
            <p className="text-gray-600 dark:text-gray-400 mb-6">
              An unexpected error occurred. Please refresh the page.
            </p>
            <button
              onClick={() => window.location.reload()}
              className="bg-primary-600 hover:bg-primary-700 text-white px-6 py-3 rounded-lg transition-colors shadow-md"
            >
              Refresh Page
            </button>
          </div>
        </div>
      );
    }
    return this.props.children;
  }
}

function App() {
  return (
    <ErrorBoundary>
      <ThemeProvider>
        <ToastProvider>
          <AuthProvider>
            <Router>
              <div className="flex flex-col min-h-screen">
                <Navbar />
                <main className="flex-grow">
                  <Suspense fallback={<PageLoader />}>
                    <Routes>
                      <Route path="/" element={<Home />} />
                      <Route path="/login" element={<Login />} />
                      <Route path="/register" element={<Register />} />
                      <Route path="/results" element={<Results />} />
                      <Route path="/search" element={<Home />} />
                      <Route
                        path="/admin"
                        element={
                          <ProtectedRoute role="admin">
                            <AdminDashboard />
                          </ProtectedRoute>
                        }
                      />
                      <Route
                        path="/pricing"
                        element={
                          <ProtectedRoute role="admin">
                            <Pricing />
                          </ProtectedRoute>
                        }
                      />
                      <Route path="/auth/callback" element={<AuthCallback />} />
                      <Route path="*" element={<NotFound />} />
                    </Routes>
                  </Suspense>
                </main>
                <Footer />
              </div>
            </Router>
          </AuthProvider>
        </ToastProvider>
      </ThemeProvider>
    </ErrorBoundary>
  );
}

export default App;
