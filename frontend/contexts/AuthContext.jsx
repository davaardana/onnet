import React, { createContext, useContext, useState, useEffect, useCallback, useRef } from 'react';

const AuthContext = createContext();

const API_BASE = import.meta.env.VITE_API_URL || '/api';

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

// Decode JWT expiry — returns true if token is expired (or expires within 30s)
const isTokenExpired = (token) => {
  try {
    const payload = JSON.parse(atob(token.split('.')[1]));
    return payload.exp * 1000 < Date.now() + 30_000;
  } catch {
    return true;
  }
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

  const [token, setToken] = useState(() => storage.get('token'));
  const [refreshToken, setRefreshToken] = useState(() => storage.get('refreshToken'));

  // isAuthenticated: token must exist AND not be expired
  const [isAuthenticated, setIsAuthenticated] = useState(() => {
    const tok = storage.get('token');
    return !!tok && !isTokenExpired(tok);
  });

  // Refs so apiFetch always sees the latest values without stale closures
  const tokenRef = useRef(token);
  const refreshTokenRef = useRef(refreshToken);
  useEffect(() => { tokenRef.current = token; }, [token]);
  useEffect(() => { refreshTokenRef.current = refreshToken; }, [refreshToken]);

  // Clears all auth state from memory and storage
  const clearAuth = useCallback(() => {
    setUser(null);
    setIsAuthenticated(false);
    setToken(null);
    setRefreshToken(null);
    storage.remove('user');
    storage.remove('token');
    storage.remove('refreshToken');
  }, []);

  // Attempts a silent token refresh; returns the new access token or null on failure
  const silentRefresh = useCallback(async (currentRefreshToken) => {
    try {
      const res = await fetch(`${API_BASE}/auth/refresh`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ refreshToken: currentRefreshToken }),
      });
      if (!res.ok) {
        clearAuth();
        return null;
      }
      const data = await res.json();
      const remember = localStorage.getItem('token') !== null;
      storage.set('token', data.token, remember);
      storage.set('refreshToken', data.refreshToken, remember);
      setToken(data.token);
      setRefreshToken(data.refreshToken);
      setIsAuthenticated(true);
      return data.token;
    } catch {
      clearAuth();
      return null;
    }
  }, [clearAuth]);

  // On mount: if access token is expired but refresh token exists, silently refresh
  useEffect(() => {
    const storedToken = storage.get('token');
    const storedRefresh = storage.get('refreshToken');
    if (storedToken && isTokenExpired(storedToken) && storedRefresh) {
      silentRefresh(storedRefresh);
    }
  }, []); // eslint-disable-line react-hooks/exhaustive-deps

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
      if (storedRefreshToken) {
        await fetch(`${API_BASE}/auth/logout`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ refreshToken: storedRefreshToken }),
        });
      }
    } catch {
      // Best-effort revocation — always clear local state regardless
    } finally {
      clearAuth();
    }
  };

  const register = (userData, authToken, refreshTokenVal) => {
    login(userData, authToken, refreshTokenVal, true);
  };

  /**
   * apiFetch — drop-in replacement for fetch() for authenticated endpoints.
   * - Automatically attaches the Bearer token.
   * - Proactively refreshes the token if it is near expiry.
   * - On 401, attempts one silent token refresh and retries.
   * - If refresh fails, clears auth state (user is effectively logged out).
   */
  const apiFetch = useCallback(async (url, options = {}) => {
    const doRequest = async (accessToken) => {
      const headers = {
        ...(options.headers || {}),
        ...(accessToken ? { Authorization: `Bearer ${accessToken}` } : {}),
      };
      return fetch(url, { ...options, headers });
    };

    let currentToken = tokenRef.current;

    // Proactively refresh before the request if token is nearly expired
    if (currentToken && isTokenExpired(currentToken)) {
      const rt = refreshTokenRef.current;
      if (rt) {
        currentToken = await silentRefresh(rt);
      } else {
        clearAuth();
        return new Response(JSON.stringify({ error: 'Session expired' }), { status: 401 });
      }
      if (!currentToken) {
        return new Response(JSON.stringify({ error: 'Session expired' }), { status: 401 });
      }
    }

    let res = await doRequest(currentToken);

    // React to unexpected 401 by trying refresh once more
    if (res.status === 401) {
      const rt = refreshTokenRef.current;
      if (rt) {
        const newToken = await silentRefresh(rt);
        if (newToken) {
          res = await doRequest(newToken);
        } else {
          clearAuth();
        }
      } else {
        clearAuth();
      }
    }

    return res;
  }, [silentRefresh, clearAuth]);

  return (
    <AuthContext.Provider value={{ user, isAuthenticated, token, refreshToken, login, logout, register, setUser, apiFetch }}>
      {children}
    </AuthContext.Provider>
  );
};
