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

# Build the application (force rebuild, don't use cache for this step)
RUN --no-cache npm run build

# Debug: Check what was built
RUN echo "=== Checking build output ===" && \
    echo "Current directory:" && pwd && \
    echo "=== .medusa directory ===" && \
    (ls -la .medusa/ 2>/dev/null || echo ".medusa directory not found") && \
    echo "=== .medusa/server directory ===" && \
    (ls -la .medusa/server/ 2>/dev/null || echo ".medusa/server not found") && \
    echo "=== .medusa/server/public directory ===" && \
    (ls -la .medusa/server/public/ 2>/dev/null || echo ".medusa/server/public not found") && \
    echo "=== Searching for index.html ===" && \
    (find .medusa -name "index.html" -type f 2>/dev/null || echo "No index.html found in .medusa") && \
    echo "=== All .medusa files ===" && \
    (find .medusa -type f 2>/dev/null | head -20 || echo "No files found in .medusa")

# Expose port
EXPOSE 9000

# Start the application (run migrations first, then start server)
CMD ["sh", "-c", "npx medusa db:migrate && npm start"]

