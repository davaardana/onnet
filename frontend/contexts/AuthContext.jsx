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

  const login = (userData, authToken, remember = true) => {
    setUser(userData);
    setIsAuthenticated(true);
    setToken(authToken);
    storage.set('user', JSON.stringify(userData), remember);
    storage.set('token', authToken, remember);
  };

  const logout = () => {
    setUser(null);
    setIsAuthenticated(false);
    setToken(null);
    storage.remove('user');
    storage.remove('token');
  };

  const register = (userData, authToken) => {
    login(userData, authToken, true);
  };

  return (
    <AuthContext.Provider value={{ user, isAuthenticated, token, login, logout, register, setUser }}>
      {children}
    </AuthContext.Provider>
  );
};
