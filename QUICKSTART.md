# 🚀 Quick Start Guide - SpamShield AI

## System Requirements
- **Python**: 3.8+
- **Node.js**: 16+
- **npm**: 7+

## Setup & Installation

### Option 1: Automated Setup (Windows)
Simply run the startup script in the project root:
```bash
startup.bat
```
This will:
1. Create a Python virtual environment
2. Install all dependencies
3. Start the backend server
4. Start the frontend development server

### Option 2: Manual Setup

#### Backend Setup
```bash
# Navigate to backend directory
cd backend

# Create virtual environment
python -m venv venv

# Activate virtual environment
# On Windows:
venv\Scripts\activate.bat
# On macOS/Linux:
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Start the backend server
python -m app.main
# Backend will run on http://localhost:8000
```

#### Frontend Setup
```bash
# In a new terminal, navigate to frontend directory
cd frontend

# Install dependencies
npm install

# Start the development server
npm run dev
# Frontend will run on http://localhost:5173
```

## Access the Application

- **Frontend**: http://localhost:5173
- **Backend API**: http://localhost:8000
- **API Documentation**: http://localhost:8000/docs (Swagger UI)
- **Alternative Docs**: http://localhost:8000/redoc (ReDoc)

## Configuration

### Environment Variables
Create a `.env` file in the project root (copy from `.env.example`):

```env
# Backend
BACKEND_HOST=127.0.0.1
BACKEND_PORT=8000
RELOAD=true

# Frontend
FRONTEND_PORT=5173

# CORS Origins (comma-separated)
ALLOWED_ORIGINS=http://localhost:5173,http://127.0.0.1:5173

# Rate Limiting (requests per minute)
RATE_LIMIT_CALLS=60

# Environment & Logging
ENVIRONMENT=development
LOG_LEVEL=INFO
```

## Features Overview

### 🔍 Spam Detection
- Send text and get instant spam/ham classification
- Confidence scores with probability breakdown
- Feature attribution explaining the prediction

### 📊 Dashboard
- Model performance metrics (Accuracy, Precision, Recall, F1)
- Dataset statistics and class distribution
- Confusion matrix visualization
- ROC curve and AUC score

### 💾 Prediction History
- Local storage of recent predictions
- Search and filter capabilities
- Export to CSV

### 🎨 User Experience
- Dark mode with system preference detection
- Responsive design for all devices
- Keyboard shortcuts (Ctrl+Enter for prediction, Ctrl+/ for theme toggle)
- Real-time character counter

## API Endpoints

### Prediction
- **POST** `/api/predict` - Make a spam/ham prediction
- **Body**: `{ "text": "your message here" }`

### Metrics
- **GET** `/api/metrics` - Get model performance metrics
- **GET** `/api/dataset-info` - Get dataset statistics
- **GET** `/api/health` - Health check endpoint

## Troubleshooting

### Backend won't start
1. Ensure Python 3.8+ is installed: `python --version`
2. Verify virtual environment is activated
3. Check port 8000 is not in use: `netstat -ano | findstr :8000` (Windows)
4. Clear Python cache: `del /s /q __pycache__`

### Frontend won't connect to backend
1. Ensure backend is running on http://localhost:8000
2. Check CORS settings in `.env` (should include frontend URL)
3. Check browser console for errors (F12)
4. Clear browser cache or use incognito mode

### Model files not found
1. Ensure `backend/app/model/` contains:
   - `spam_model.pkl`
   - `tfidf.pkl`
   - `metrics.json`
2. Run the training script if missing: `python backend/app/services/trainer.py`

## Development Tips

### Adding new features to backend
1. Create endpoints in `backend/app/api/endpoints.py`
2. Add request/response models using Pydantic
3. Test with `pytest backend/app/tests/`

### Adding new pages to frontend
1. Create component in `frontend/src/pages/`
2. Add route in `frontend/src/App.jsx`
3. Use `AppContext` for global state management

### Debugging
- Backend logs are printed in terminal
- Frontend errors visible in browser console (F12)
- Enable verbose logging by setting `LOG_LEVEL=DEBUG` in `.env`

## Performance Optimization

### Backend
- In-memory rate limiting (60 requests/minute per IP)
- Lazy loading of NLTK resources
- Cached model and vectorizer

### Frontend
- Vite for fast hot module replacement
- TailwindCSS for optimized styling
- Framer Motion for efficient animations
- React Router for code splitting

## Deployment

For production deployment, see the main [README.md](README.md).

---

**Need help?** Check the logs and browser console for detailed error messages.
