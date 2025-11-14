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

# Build the application
RUN npm run build

# Verify admin build output exists
RUN test -f .medusa/server/public/index.html || (echo "ERROR: Admin build failed - index.html not found" && exit 1)

# Expose port
EXPOSE 9000

# Start the application (run migrations first, then start server)
CMD ["sh", "-c", "npx medusa db:migrate && npm start"]

