@echo off
REM Spam Detection App - Development Startup Script for Windows

echo.
echo ========================================
echo   SpamShield AI - Development Setup
echo ========================================
echo.

REM Set working directory
cd /d "%~dp0"

REM Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Python is not installed or not in PATH
    pause
    exit /b 1
)

REM Check if Node.js is installed
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Node.js is not installed or not in PATH
    pause
    exit /b 1
)

echo [1/5] Python and Node.js verified
echo.

REM Setup Backend
echo [2/5] Setting up Backend...
cd backend
if not exist venv (
    echo Creating virtual environment...
    python -m venv venv
)

call venv\Scripts\activate.bat
echo Installing backend dependencies...
pip install -r requirements.txt -q
cd ..
echo Backend setup complete!
echo.

REM Setup Frontend
echo [3/5] Setting up Frontend...
cd frontend
echo Installing frontend dependencies...
call npm install -q
cd ..
echo Frontend setup complete!
echo.

REM Start Backend
echo [4/5] Starting Backend Server...
cd backend
call venv\Scripts\activate.bat
start "Backend - SpamShield AI" cmd /k "python -m app.main"
cd ..
echo Backend started on http://localhost:8000
echo.

REM Start Frontend
echo [5/5] Starting Frontend Dev Server...
cd frontend
start "Frontend - SpamShield AI" cmd /k "npm run dev"
cd ..
echo Frontend started on http://localhost:5173
echo.

echo ========================================
echo   Development servers are running!
echo ========================================
echo.
echo Backend API:   http://localhost:8000
echo Frontend:      http://localhost:5173
echo API Docs:      http://localhost:8000/docs
echo.
echo Press Ctrl+C in any terminal to stop the servers
echo.
pause
