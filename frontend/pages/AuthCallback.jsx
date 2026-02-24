import React, { useEffect } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';

const API_BASE = import.meta.env.VITE_API_URL || '/api';

const AuthCallback = () => {
  const [searchParams] = useSearchParams();
  const navigate = useNavigate();
  const { login } = useAuth();

  useEffect(() => {
    const token = searchParams.get('token');

    if (!token) {
      navigate('/login?error=no_token');
      return;
    }

    // Verify token with backend and get real user data
    fetch(`${API_BASE}/auth/me`, {
      headers: { Authorization: `Bearer ${token}` }
    })
      .then(async (res) => {
        if (!res.ok) throw new Error('Token verification failed');
        return res.json();
      })
      .then(({ user }) => {
        login(user, token);
        if (user.role === 'admin') {
          navigate('/admin');
        } else {
          navigate('/');
        }
      })
      .catch((error) => {
        console.error('AuthCallback error:', error);
        navigate('/login?error=invalid_token');
      });
  }, [searchParams, navigate, login]);

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50 dark:bg-gray-900">
      <div className="text-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600 mx-auto"></div>
        <p className="mt-4 text-gray-600 dark:text-gray-400">Completing login...</p>
      </div>
    </div>
  );
};

export default AuthCallback;
