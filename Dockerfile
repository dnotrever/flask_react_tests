FROM python:3.13-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    TZ=America/Sao_Paulo

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl tzdata git openssh-client bash build-essential sqlite3 \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 20.x
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get update && apt-get install -y nodejs \
    && npm install -g npm@latest \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN groupadd -g 1000 appuser && \
    useradd -m -u 1000 -g appuser -s /bin/bash appuser

# Set working directory
WORKDIR /app

# Install Python dependencies
COPY backend/requirements.txt backend/requirements.txt
RUN pip install --no-cache-dir -r backend/requirements.txt

# Copy application code
COPY . /app

# Install frontend dependencies
COPY frontend/package.json frontend/package-lock.json*
RUN cd frontend && npm install --no-audit --no-fund

# Set ownership and permissions
RUN chown -R appuser:appuser /app && \
    chmod +x /app/scripts/*.sh

USER appuser

CMD []
