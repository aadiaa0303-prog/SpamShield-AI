# SpamShield AI

> AI Powered Spam & Ham Message Detection using Machine Learning.

SpamShield AI is a production-ready machine learning web application that predicts whether a given SMS or text message is **Spam** or **Ham**. The application uses a custom-trained **Multinomial Naive Bayes** model vectorizing features through a **TF-IDF Vectorizer**. It is packaged inside a high-performance **FastAPI** backend and served via a premium, Apple-inspired responsive **React** user interface built with **Vite**, **Tailwind CSS**, and **Framer Motion**.

---

## Key Features

- **High Accuracy Model**: Evaluates text messages with ~97.7% validation accuracy and 100% spam precision.
- **Explainable AI (XAI)**: Displays real-time feature attribution showing which specific words in the text contributed most to the classification.
- **Interactive Dashboard**: Explores the SMS dataset balance, model performance (Precision, Recall, F1), word importance distributions, and confusion matrices.
- **Advanced UX**:
  - Dark Mode support with system preference memory.
  - Live character counter with pasted text detection hooks.
  - Interactive gauge and progress visualization dials.
  - Local prediction history with custom search filter and single-item delete hooks.
  - **CSV Export**: Downloads recent checks directly to local Excel/CSV format.
  - **Keyboard Shortcuts**: Use `Ctrl+Enter` to trigger prediction, and `Ctrl+/` to toggle theme.
- **Security & Best Practices**:
  - In-memory sliding window rate limiter to prevent API scraping.
  - Custom input length validation checks (Max 5,000 characters).
  - CORS security configurations.

---

## Technical Stack

### Machine Learning
- **Algorithm**: Multinomial Naive Bayes
- **Feature Engineering**: TF-IDF Vectorizer (max_features=5000, ngram_range=(1,2))
- **Preprocessing**: NLTK (Stopwords removal & WordNet Lemmatization)
- **Serialization**: Joblib

### Backend
- **Framework**: FastAPI (Python)
- **Web Server**: Uvicorn
- **Testing**: PyTest & HTTPX Client
- **Rate Limiting**: Sliding window middleware

### Frontend
- **Bundler & Libs**: Vite + React (JS)
- **Styling**: Tailwind CSS v4 (PostCSS)
- **Animations**: Framer Motion
- **Visuals & Icons**: Chart.js, React-Chartjs-2, Lucide Icons

---

## Folder Structure

```
spam-or-ham-detection/
│
├── backend/
│   ├── app/
│   │   ├── api/
│   │   │   ├── __init__.py
│   │   │   └── endpoints.py
│   │   ├── config/
│   │   │   ├── __init__.py
│   │   │   └── settings.py
│   │   ├── dataset/
│   │   │   ├── spam.csv            # Original Dataset
│   │   │   └── cleaned_spam.csv    # Cleaned and processed dataset
│   │   ├── model/
│   │   │   ├── spam_model.pkl      # Trained Model (Serialized)
│   │   │   ├── tfidf.pkl           # Fitted Vectorizer (Serialized)
│   │   │   └── metrics.json        # Pre-calculated validation metrics & stats
│   │   ├── services/
│   │   │   ├── __init__.py
│   │   │   ├── predictor.py        # Inference and Explanation engine
│   │   │   └── trainer.py          # ML Pipeline training script
│   │   ├── tests/
│   │   │   ├── __init__.py
│   │   │   └── test_api.py         # Integration & unit endpoint tests
│   │   │
│   │   ├── __init__.py
│   │   └── main.py                 # FastAPI Entry point & Rate limiter
│   │
│   ├── requirements.txt            # Python Dependencies
│   └── venv/                       # Virtual Environment
│
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   │   ├── Footer.jsx
│   │   │   ├── Navbar.jsx
│   │   │   └── Toast.jsx
│   │   ├── context/
│   │   │   └── AppContext.jsx      # Global State, Themes & History context
│   │   ├── pages/
│   │   │   ├── AboutMLPage.jsx
│   │   │   ├── ContactPage.jsx
│   │   │   ├── DashboardPage.jsx
│   │   │   ├── DetectionPage.jsx
│   │   │   ├── LandingPage.jsx
│   │   │   └── NotFoundPage.jsx
│   │   ├── App.jsx                 # Routes and layout binding
│   │   ├── index.css               # Styling tokens, utilities & custom scrollbar
│   │   └── main.jsx
│   │
│   ├── postcss.config.js
│   ├── tailwind.config.js
│   ├── package.json                # Node Dependencies
│   └── vite.config.js
│
├── .gitignore
├── LICENSE                         # MIT License
└── README.md                       # Documentation
```

---

## Machine Learning Pipeline

### Data Preprocessing
1. **Label Mapping**: Converts raw labels `spam` to `1` and `ham` to `0`.
2. **Text Cleaning**: Normalizes characters to lowercase, strips punctuation marks/symbols, and removes numbers.
3. **Lemmatization**: Splits messages into tokens, filters out NLTK English stopwords, and lemmatizes tokens to their dictionary root format.
4. **Vocabulary Fitting**: Feeds tokens into a TF-IDF vectorizer mapping unigrams and bigrams to a sparse matrix of 5,000 top vocabulary terms.

### Metrics Summary
- **Accuracy**: `97.77%`
- **Precision**: `100.00%` (0 false spam flags in validation)
- **Recall**: `83.33%`
- **F1 Score**: `90.91%`
- **AUC Score**: `98.31%`

---

## Installation & Setup

### Prerequisites
- Python 3.10+
- Node.js 18+ & NPM

### 1. Setup Backend
```bash
# Navigate to backend folder
cd backend

# Create virtual environment
python -m venv venv

# Activate virtual environment
# On Windows:
.\venv\Scripts\activate
# On macOS/Linux:
source venv/bin/activate

# Install requirements
pip install -r requirements.txt
```

### 2. Train Model Pipeline
To download the SMS Spam dataset, clean the labels, evaluate, and serialize the models:
```bash
python app/services/trainer.py
```
This script downloads `spam.csv` from verified sources, processes it, and generates:
- `backend/app/model/spam_model.pkl`
- `backend/app/model/tfidf.pkl`
- `backend/app/model/metrics.json`

### 3. Run Backend Server
```bash
python app/main.py
```
The backend API will start on [http://127.0.0.1:8000](http://127.0.0.1:8000). You can check docs at `/docs`.

### 4. Setup Frontend
Open a new terminal window:
```bash
# Navigate to frontend folder
cd frontend

# Install packages
npm install

# Run Vite dev server
npm run dev
```
The React web application will start on [http://localhost:5173](http://localhost:5173).

---

## API Specifications

### `POST /api/predict`
Analyze a string of text to determine classification.

- **Request Body**:
  ```json
  {
    "text": "Congratulations! You won a free iPhone."
  }
  ```
- **Response Body**:
  ```json
  {
    "prediction": "Spam",
    "confidence": 99.32,
    "probability": {
      "spam": 99.32,
      "ham": 0.68
    },
    "explanation": {
      "top_words": [
        { "word": "congratulations", "score": 2.54, "is_spam_indicator": true },
        { "word": "won", "score": 1.93, "is_spam_indicator": true }
      ],
      "summary": "Highly typical spam words found: congratulations, won."
    }
  }
  ```

### `GET /api/metrics`
Retrieve pre-compiled model evaluation stats.
- **Response Body**:
  ```json
  {
    "accuracy": 0.9777,
    "precision": 1.0,
    "recall": 0.8333,
    "f1": 0.9091,
    "confusion_matrix": { "tn": 894, "fp": 0, "fn": 23, "tp": 115 },
    "roc_curve": [...]
  }
  ```

### `GET /api/dataset-info`
Retrieve dataset details and token distributions.

### `GET /api/health`
Checks API service health. Returns `{"status": "running"}`.

---

## Running Tests
Ensure backend components are verified:
```bash
cd backend
.\venv\Scripts\python -m pytest
```

---

## License
Licensed under the [MIT License](LICENSE).
