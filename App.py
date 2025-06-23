from flask import Flask, request, jsonify
from flask_cors import CORS
import os
from Expression_Detector import detect_expression

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "https://sego-smart-fe.vercel.app"}}, supports_credentials=True)

# Log saat server startup
print("Flask Server is running and ready to receive requests...")

# Endpoint untuk mengunggah gambar dan mendapatkan rating kepuasan
@app.route("/analyze", methods=["POST"])
def analyze_image():
    print("Received request at /analyze")

    if 'file' not in request.files:
        print("Tidak ada file di request")
        return jsonify({"error": "Tidak ada file yang diunggah"}), 400

    file = request.files['file']
    file_path = "temp.jpg"
    file.save(file_path)
    print(f"File berhasil disimpan sementara sebagai {file_path}")

    try:
        # Analisis ekspresi menggunakan fungsi di expression_detector.py
        result = detect_expression(file_path)
        print(" Ekspresi berhasil dianalisis:", result)
    except Exception as e:
        print(" Gagal menganalisis ekspresi:", str(e))
        result = {"error": "Gagal menganalisis ekspresi"}

    # Hapus gambar sementara setelah analisis
    if os.path.exists(file_path):
        os.remove(file_path)
        print(f" File sementara {file_path} dihapus")

    return jsonify(result)

if __name__ == "__main__":
    print(" Memulai Flask server...")
    app.run(debug=True)
