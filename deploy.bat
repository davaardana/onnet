@echo off
echo ========================================
echo  Netpoint Portal - Docker Deployment
echo ========================================
echo.

echo [Checking Docker...]
docker --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Docker not installed!
    echo Please install Docker Desktop from: https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)

echo Docker installed: OK
echo.

echo [Checking Docker Engine...]
docker ps >nul 2>&1
if errorlevel 1 (
    echo.
    echo ==========================================
    echo  Docker Desktop is not running!
    echo ==========================================
    echo.
    echo Please start Docker Desktop first:
    echo 1. Open Docker Desktop from Start Menu
    echo 2. Wait for Docker to fully start
    echo 3. Run this script again
    echo.
    echo Starting Docker Desktop automatically...
    start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
    echo.
    echo Waiting 30 seconds for Docker to start...
    timeout /t 30 /nobreak
    echo.
    echo Checking again...
    docker ps >nul 2>&1
    if errorlevel 1 (
        echo Docker still not ready. Please wait and try again.
        pause
        exit /b 1
    )
)

echo Docker Engine: Running
echo.

echo ========================================
echo  Starting Build Process
echo ========================================
echo.

echo [1/3] Building containers...
docker-compose build
if errorlevel 1 (
    echo Build failed!
    pause
    exit /b 1
)

echo.
echo [2/3] Starting services...
docker-compose up -d
if errorlevel 1 (
    echo Failed to start services!
    pause
    exit /b 1
)

echo.
echo [3/3] Waiting for services to be ready...
timeout /t 15 /nobreak >nul

echo.
echo ========================================
echo  Deployment Complete!
echo ========================================
echo.
echo Services Status:
docker-compose ps
echo.
echo ========================================
echo  Access Your Application
echo ========================================
echo.
echo Frontend:  http://localhost
echo Backend:   http://localhost:5000/api
echo Database:  localhost:5432
echo.
echo ========================================
echo  Useful Commands
echo ========================================
echo.
echo View logs:     docker-compose logs -f
echo Stop all:      docker-compose down
echo Restart:       docker-compose restart
echo Database CLI:  docker exec -it netpoint-postgres psql -U netpoint_user -d netpoint_db
echo.
pause
