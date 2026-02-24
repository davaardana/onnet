import React, { createContext, useContext, useState } from 'react';

const AuthContext = createContext();

// Storage helper — uses localStorage (persistent) or sessionStorage (tab-only)
const storage = {
  set: (key, value, remember = true) => {
    (remember ? localStorage : sessionStorage).setItem(key, value);
  },
  get: (key) => localStorage.getItem(key) ?? sessionStorage.getItem(key),
  remove: (key) => {
    localStorage.removeItem(key);
    sessionStorage.removeItem(key);
  },
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within AuthProvider');
  }
  return context;
};

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(() => {
    try {
      const savedUser = storage.get('user');
      return savedUser ? JSON.parse(savedUser) : null;
    } catch {
      storage.remove('user');
      return null;
    }
  });
  const [isAuthenticated, setIsAuthenticated] = useState(() => {
    return storage.get('token') !== null;
  });
  const [token, setToken] = useState(() => {
    return storage.get('token');
  });
  const [refreshToken, setRefreshToken] = useState(() => {
    return storage.get('refreshToken');
  });

  const login = (userData, authToken, refreshTokenVal, remember = true) => {
    setUser(userData);
    setIsAuthenticated(true);
    setToken(authToken);
    storage.set('user', JSON.stringify(userData), remember);
    storage.set('token', authToken, remember);
    if (refreshTokenVal) {
      setRefreshToken(refreshTokenVal);
      storage.set('refreshToken', refreshTokenVal, remember);
    }
  };

  const logout = async () => {
    try {
      const storedRefreshToken = storage.get('refreshToken');
      const storedToken = storage.get('token');
      if (storedToken) {
        const apiUrl = import.meta.env.VITE_API_URL || '/api';
        await fetch(`${apiUrl}/auth/logout`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${storedToken}`,
          },
          body: JSON.stringify({ refreshToken: storedRefreshToken }),
        });
      }
    } catch {
      // Best-effort revocation — always clear local state regardless
    } finally {
      setUser(null);
      setIsAuthenticated(false);
      setToken(null);
      setRefreshToken(null);
      storage.remove('user');
      storage.remove('token');
      storage.remove('refreshToken');
    }
  };

  const register = (userData, authToken, refreshTokenVal) => {
    login(userData, authToken, refreshTokenVal, true);
  };

  return (
    <AuthContext.Provider value={{ user, isAuthenticated, token, refreshToken, login, logout, register, setUser }}>
      {children}
    </AuthContext.Provider>
  );
};
