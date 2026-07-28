import axios, { AxiosInstance } from 'axios';

// Use environment variable or default to localhost
const API_URL = process.env.REACT_APP_API_URL ||
                process.env.EXPO_PUBLIC_API_URL ||
                'http://localhost:3000';

export const apiClient: AxiosInstance = axios.create({
  baseURL: `${API_URL}/api/v2`,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Storage abstraction for web and mobile
const getStorage = () => {
  // React Native AsyncStorage or Web localStorage
  if (typeof window !== 'undefined') {
    return window.localStorage;
  }
  // For React Native, return a dummy object (AsyncStorage must be imported separately)
  return {
    getItem: async (key: string) => null,
    setItem: async (key: string, value: string) => {},
    removeItem: async (key: string) => {},
  };
};

// Add token to requests
apiClient.interceptors.request.use(async (config) => {
  const storage = getStorage();
  let token = null;

  if (storage.getItem) {
    token = await (storage.getItem as any)('auth_token');
  } else if ((storage as any).getItem) {
    token = storage.getItem('auth_token');
  }

  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Handle errors
apiClient.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      const storage = getStorage();
      if (storage.removeItem) {
        storage.removeItem('auth_token');
      }
      // Redirect handled by app-specific code
    }
    return Promise.reject(error);
  }
);

export default apiClient;
