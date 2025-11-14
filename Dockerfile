# Use Node.js 20 LTS
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package.json package-lock.json* ./

# Install dependencies (including dev dependencies needed for build)
RUN if [ -f package-lock.json ]; then npm install --legacy-peer-deps; \
    else echo "package-lock.json not found. Run 'npm install' first." && exit 1; \
    fi

# Copy source code
COPY . .

# Set NODE_ENV for build
ENV NODE_ENV=production

# Add a cache-busting step to force rebuild (change this comment to invalidate cache)
# Cache bust: 2025-11-14

# Build the application
RUN npm run build

# Fix admin build location - find and copy index.html to public root
RUN echo "=== Fixing admin build location ===" && \
    echo "Searching for index.html..." && \
    INDEX_FILE=$(find .medusa -name "index.html" -type f 2>/dev/null | head -1) && \
    if [ -n "$INDEX_FILE" ]; then \
        echo "Found index.html at: $INDEX_FILE" && \
        mkdir -p .medusa/server/public && \
        cp "$INDEX_FILE" .medusa/server/public/index.html && \
        echo "✅ Copied to .medusa/server/public/index.html" && \
        ls -la .medusa/server/public/index.html; \
    else \
        echo "⚠️ index.html not found anywhere in .medusa" && \
        echo "Listing .medusa/server/public structure:" && \
        ls -laR .medusa/server/public/ 2>/dev/null | head -30; \
    fi

# Expose port
EXPOSE 9000

# Start the application (run migrations first, then start server)
CMD ["sh", "-c", "npx medusa db:migrate && npm start"]

