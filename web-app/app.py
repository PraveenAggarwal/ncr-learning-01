import os
from flask import Flask, jsonify

app = Flask(__name__)

message = os.environ.get("APP_MESSAGE", "Hello from the Edge!")

@app.route("/")
def index():
    return f"<html><body><h1>{message}</h1></body></html>"

@app.route("/api/message")
def api_message():
    return jsonify({"message": message})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

