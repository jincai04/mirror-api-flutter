from flask import Flask, jsonify, request
from flask_cors import CORS
from dotenv import load_dotenv
import os

load_dotenv()

app = Flask(__name__)
CORS(app)  # Enable CORS for all origins

# Mock user-token mapping (replace with Firestore/Airtable integration)
USER_TOKENS = {
    "user@example.com": "mock_utoken_123"
}

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})

@app.route('/genset', methods=['POST'])
def get_genset():
    data = request.get_json()
    if not data:
        return jsonify({"error": "Missing request data"}), 400

    utoken = None

    # Check if email or utoken is provided
    if 'email' in data and data['email']:
        email = data['email']
        utoken = USER_TOKENS.get(email)
        if not utoken:
            return jsonify({"error": "No utoken found for user email"}), 404
    elif 'utoken' in data and data['utoken']:
        utoken = data['utoken']
    else:
        return jsonify({"error": "Missing email or utoken"}), 400

    # Validate utoken against known tokens
    if utoken not in USER_TOKENS.values():
        return jsonify({"error": "Invalid utoken"}), 404

    # Mock SmartGen API call (replace with real API integration)
    # In production, use SMARTGEN_API_KEY = os.getenv('SMARTGEN_API_KEY')
    genset_data = {
        "genset_id": f"GEN-{utoken[-4:]}",  # Mock ID based on utoken
        "status": "running",
        "power": "50kW"
    }

    return jsonify(genset_data)

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    print(f"Running on http://localhost:{port}")
    app.run(host='0.0.0.0', port=port)
