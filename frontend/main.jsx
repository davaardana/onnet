import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.jsx'
import './index.css'

// Only silence noisy browser extension errors in development
if (import.meta.env.DEV && typeof window !== 'undefined') {
  const silenceExtensionErrors = (event) => {
    const message = event?.message || event?.reason?.message || ''
    const source = event?.filename || ''
    if (/disconnected port object/i.test(message) || /proxy\.js/i.test(source)) {
      event.preventDefault?.()
      event.stopImmediatePropagation?.()
    }
  }
  window.addEventListener('error', silenceExtensionErrors, true)
  window.addEventListener('unhandledrejection', silenceExtensionErrors, true)
}

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
)
