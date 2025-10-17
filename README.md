# Mirror API and Flutter Integration

This project provides a production-ready local Mirror API backend with external access via Ngrok, and a Flutter frontend that fetches and displays SmartGen genset data.

## Project Structure

- `backend/`: Python Flask server with Ngrok integration, CORS, and environment variable support
- `flutter_app/`: Flutter application for displaying genset data with dynamic URL configuration

## Backend Setup

### Prerequisites

- Python 3.x
- Ngrok account (for external access)

### Installation

1. Navigate to the backend directory:
   ```
   cd backend
   ```

2. Install dependencies:
   ```
   pip install -r requirements.txt
   ```

3. (Optional) Create a `.env` file for environment variables:
   ```
   SMARTGEN_API_KEY=your_api_key_here
   FIREBASE_SERVICE_ACCOUNT_KEY=path_to_key.json
   PORT=5000
   ```

4. (Optional) Set up Ngrok authentication token:
   ```
   ngrok config add-authtoken YOUR_NGROK_AUTH_TOKEN
   ```

### Running the Server

Run the Flask server with Ngrok integration:
```
python app.py
```

The server will start on `http://0.0.0.0:<PORT>` (default 5000) and Ngrok will provide a public HTTPS URL. The Ngrok URL will be printed in the console.

Example output:
```
Ngrok public URL: https://abc123.ngrok.io
```

## Flutter App Setup

### Prerequisites

- Flutter SDK
- Android Studio or Xcode for running on device/emulator

### Installation

1. Navigate to the Flutter app directory:
   ```
   cd flutter_app
   ```

2. Install dependencies:
   ```
   flutter pub get
   ```

3. Run the app:
   ```
   flutter run
   ```

4. In the app, enter the Ngrok URL and your utoken to fetch genset data.

## API Endpoints

### GET /health

Returns server health status.

**Response:**
```json
{
  "status": "ok"
}
```

### POST /genset

Fetches SmartGen genset data using the provided utoken.

**Request Body:**
```json
{
  "utoken": "user_token_here"
}
```

**Response:**
```json
{
  "genset_id": "GEN-1234",
  "status": "running",
  "power": "50kW"
}
```

## Testing the API

You can test the API using curl:

```bash
# Test health endpoint
curl http://localhost:5000/health

# Test genset endpoint with valid utoken (local)
curl -X POST http://localhost:5000/genset \
  -H "Content-Type: application/json" \
  -d '{"utoken": "mock_utoken_123"}'

# Test genset endpoint with invalid utoken (should return error)
curl -X POST http://localhost:5000/genset \
  -H "Content-Type: application/json" \
  -d '{"utoken": "invalid_token"}'

# Test genset endpoint (via Ngrok)
curl -X POST https://your-ngrok-url.ngrok.io/genset \
  -H "Content-Type: application/json" \
  -d '{"utoken": "mock_utoken_123"}'
```

## Environment Variables

The backend supports the following environment variables:

- `SMARTGEN_API_KEY`: API key for SmartGen service
- `FIREBASE_SERVICE_ACCOUNT_KEY`: Path to Firebase service account key for user mapping
- `PORT`: Server port (default: 5000)

## Production Enhancements

- **Real SmartGen API Integration**: Replace the mock data in `/genset` endpoint with actual API calls using `SMARTGEN_API_KEY`.
- **Firestore/Airtable Integration**: Implement user-token mapping using Firebase Firestore or Airtable instead of the mock dictionary.
- **Error Handling and Logging**: Add comprehensive logging and error handling for production use.

## Notes

- The Flask server enables CORS for all origins to allow Flutter app access.
- The server port is configurable via the `PORT` environment variable.
- Ngrok provides a secure HTTPS tunnel to the local server.
- The Flutter app supports dynamic URL and utoken configuration.
- Pull-to-refresh functionality is available in the Flutter app.
- Update the Ngrok URL in the Flutter app each time you restart the backend server.
