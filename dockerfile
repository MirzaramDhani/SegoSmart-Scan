# Gunakan image Python yang ringan
FROM python:3.10-slim

# Install libGL dan dependensi lainnya
RUN apt-get update && apt-get install -y \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy semua file
COPY . .

# Upgrade pip dan install dependencies
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Jalankan server menggunakan gunicorn
CMD ["gunicorn", "App:app", "--bind", "0.0.0.0:8080"]
