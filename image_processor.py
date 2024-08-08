from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/process_image', methods=['POST'])
def process_image():
    # Your processing code here
    result = {"message": "Processed image successfully"}  # Example result
    return jsonify(result)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
