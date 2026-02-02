#!/bin/bash

echo "========================================"
echo " Netpoint Portal - Quick Start"
echo "========================================"
echo ""

echo "[1/4] Checking Docker..."
if ! command -v docker &> /dev/null; then
    echo "ERROR: Docker not found. Please install Docker first."
    exit 1
fi

echo "[2/4] Building Docker containers..."
docker-compose build

echo "[3/4] Starting services..."
docker-compose up -d

echo "[4/4] Waiting for services to be ready..."
sleep 10

echo ""
echo "========================================"
echo " Services are now running!"
echo "========================================"
echo ""
echo "Frontend:  http://localhost"
echo "Backend:   http://localhost:5000/api"
echo "Database:  localhost:5432"
echo ""
echo "View logs: docker-compose logs -f"
echo "Stop:      docker-compose down"
echo ""
