import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.jsx'
import './index.css'

// Silence noisy extension errors like "disconnected port object" so real errors stay visible
const silenceExtensionErrors = (event) => {
  const message = event?.message || event?.reason?.message || ''
  const source = event?.filename || ''
  if (/disconnected port object/i.test(message) || /proxy\.js/i.test(source)) {
    event.preventDefault?.()
    event.stopImmediatePropagation?.()
  }
}

if (typeof window !== 'undefined') {
  window.addEventListener('error', silenceExtensionErrors, true)
  window.addEventListener('unhandledrejection', silenceExtensionErrors, true)
}

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
)
