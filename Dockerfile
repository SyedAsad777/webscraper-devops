# Stage 1: Web scraper using Puppeteer
FROM node:23-slim AS scraper

# Install Chromium dependencies
RUN apt-get update && apt-get install -y \
    chromium \
    fonts-liberation \
    libnss3 \
    libatk-bridge2.0-0 \
    libxss1 \
    libasound2 \
    libgbm1 \
    wget \
    --no-install-recommends && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Node packages
COPY package.json ./
RUN npm install

# Copy scraper script
COPY scrape.js ./

# Set default scrape URL, override with --build-arg SCRAPE_URL
ARG SCRAPE_URL=https://books.toscrape.com
ENV SCRAPE_URL=${SCRAPE_URL}

# Run the scraper
RUN node scrape.js

# Stage 2: Lightweight Flask API server
FROM python:alpine


WORKDIR /app

# Copy only required files
COPY server.py requirements.txt ./ 
COPY --from=scraper /app/scraped_data.json ./scraped_data.json

# Install Python deps
RUN pip install --no-cache-dir -r requirements.txt

# Expose Flask port
EXPOSE 5000

# Start Flask API
CMD ["python", "server.py"]



