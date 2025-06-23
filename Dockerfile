FROM python:3.10-slim-bullseye

ENV PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Upgrade pip and install Python dependencies
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Expose port (optional, default gunicorn runs on 5000)
EXPOSE 5000

# Start server with gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]

