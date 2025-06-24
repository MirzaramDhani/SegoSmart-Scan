# Start with a Python base image
FROM python:3.12-slim

# Install necessary system dependencies (including OpenCV's requirements)
RUN apt-get update && \
    apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 && \
    rm -rf /var/lib/apt/lists/*

# Set a working directory inside the container
WORKDIR /app

# Copy only the requirements file first
COPY requirements.txt .

# Create a virtual environment and install dependencies
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

# Buat virtual env dan install pip
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install hanya opencv-python-headless dulu
RUN pip install --no-cache-dir opencv-python-headless

# Install DeepFace TANPA dependensi (agar tidak install opencv-python)
RUN pip install --no-cache-dir deepface --no-deps

# Install sisa requirements (jangan install ulang deepface / opencv)
RUN pip install --no-cache-dir -r requirements.txt

RUN pip show opencv-python || echo "opencv-python not found"
RUN pip show opencv-python-headless

COPY . /app

EXPOSE 5000

CMD ["sh", "-c", "gunicorn App:app --bind 0.0.0.0:${PORT}"]