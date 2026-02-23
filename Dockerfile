# Frontend Dockerfile
FROM node:18-alpine as builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies (include devDependencies for build)
RUN npm install

# Copy source code
COPY . .

# Build-time environment variables
ARG VITE_API_URL
ARG VITE_APP_NAME=Netpoint
ARG VITE_APP_TAGLINE="Gateway to Connect Your Businesses to Indonesia"
ENV VITE_API_URL=${VITE_API_URL}
ENV VITE_APP_NAME=${VITE_APP_NAME}
ENV VITE_APP_TAGLINE=${VITE_APP_TAGLINE}

# Build app
RUN npm run build

# Production stage
FROM nginx:alpine

# Hide version
RUN sed -i 's/worker_processes.*/worker_processes auto;/' /etc/nginx/nginx.conf

# Copy built assets from builder
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
