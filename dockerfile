# Gunakan image dasar Python
FROM python:3.12-slim

# Install libGL dan dependensi lain
RUN apt-get update && apt-get install -y \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy semua file ke dalam container
COPY . .

# Install semua Python package
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Jalankan server Flask menggunakan gunicorn
CMD ["gunicorn", "App:app", "--bind", "0.0.0.0:8080"]
