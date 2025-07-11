from flask import Flask, jsonify
app = Flask(__name__)

@app.route('/')
def home():
    return jsonify(message="👷‍♂️ Packing Bitcoin in a wheelbarrow!")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
