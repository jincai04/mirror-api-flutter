from flask import Flask, jsonify, request
from flask_cors import CORS
from dotenv import load_dotenv
import os
import requests

load_dotenv()

app = Flask(__name__)
CORS(app)  # Enable CORS for all origins

# Mock user-token mapping (replace with Firestore/Airtable integration)
USER_TOKENS = {
    "user@example.com": "bebf6914640ec3ed6bf00398fb7969da"
}

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})

@app.route('/genset', methods=['GET'])
def get_genset_list():
    # Use the hardcoded utoken for SmartGen API
    utoken = "bebf6914640ec3ed6bf00398fb7969da"

    try:
        # Call SmartGen API
        smartgen_url = f"https://www.smartgencloudplus.com/yewu/third/genset/list?utoken={utoken}&page=1&per_page=10"
        print(f"Calling SmartGen API: {smartgen_url}")

        response = requests.get(smartgen_url, timeout=30)
        response.raise_for_status()  # Raise exception for bad status codes

        smartgen_data = response.json()
        print(f"SmartGen API response received")

        # Extract only the data.list array
        genset_list = smartgen_data.get("data", {}).get("list", [])
        print(f"Returning {len(genset_list)} gensets")

        # Return only the genset list array
        return jsonify(genset_list)

    except requests.exceptions.RequestException as e:
        print(f"Error calling SmartGen API: {e}")
        return jsonify({"error": "Failed to fetch data from SmartGen API", "details": str(e)}), 500
    except Exception as e:
        print(f"Unexpected error: {e}")
        return jsonify({"error": "Internal server error", "details": str(e)}), 500

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    print(f"Starting Flask app on port {port}")
    app.run(host='0.0.0.0', port=port, debug=False)
