FROM python:3.12-slim

RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .

# Buat virtual environment
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# 🔥 Install opencv headless dan deepface manual
RUN pip install --no-cache-dir opencv-python-headless==4.8.0.74
RUN pip install --no-cache-dir deepface --no-deps

# Install sisa dependency dari requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY . /app

EXPOSE 5000

CMD ["sh", "-c", "gunicorn App:app --bind 0.0.0.0:${PORT}"]
