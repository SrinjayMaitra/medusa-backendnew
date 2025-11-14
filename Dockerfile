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

# Debug: Check what was built and fix admin build location
RUN echo "=== Checking build output ===" && \
    echo "Current directory:" && pwd && \
    echo "=== Searching for index.html ===" && \
    (find .medusa -name "index.html" -type f 2>/dev/null || echo "No index.html found in .medusa") && \
    echo "=== .medusa/server/public structure ===" && \
    (ls -laR .medusa/server/public/ 2>/dev/null | head -50 || echo ".medusa/server/public not found") && \
    echo "=== Fixing admin build location ===" && \
    (if [ -f .medusa/server/public/admin/index.html ]; then \
        echo "Found index.html in admin subdirectory, copying to public root" && \
        cp .medusa/server/public/admin/index.html .medusa/server/public/index.html && \
        echo "✅ index.html copied to expected location"; \
    elif [ -f .medusa/server/public/index.html ]; then \
        echo "✅ index.html already in correct location"; \
    else \
        echo "⚠️ index.html not found, but continuing build"; \
    fi)

# Expose port
EXPOSE 9000

# Start the application (run migrations first, then start server)
CMD ["sh", "-c", "npx medusa db:migrate && npm start"]

