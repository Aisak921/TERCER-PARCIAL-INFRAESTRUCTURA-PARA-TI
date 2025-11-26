# Use a specific version of Node.js with Alpine for smaller image
FROM node:22-alpine AS builder

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy only dependency files first (better caching)
COPY package*.json ./

# Install app dependencies with security audit and clean cache
RUN npm ci --only=production && \
    npm audit fix && \
    npm cache clean --force

# Copy the rest of the application code
COPY . .

# Build stage - lightweight production image
FROM node:22-alpine

# Create a non-root user for security
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

WORKDIR /usr/src/app

# Copy built dependencies and code from builder
COPY --from=builder --chown=nodejs:nodejs /usr/src/app .

# Switch to non-root user
USER nodejs

# Expose the port the app runs on
EXPOSE 3000

# Add health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD node -e "require('http').get('http://localhost:3000', (r) => {if (r.statusCode !== 200) throw new Error(r.statusCode)})"

# Define the command to run the application
CMD ["npm", "start"]
