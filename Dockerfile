FROM node:18-alpine

# Install dependencies
RUN apk add --no-cache \
    bash \
    curl \
    jq

# Install Artillery globally
RUN npm install -g artillery@latest

# Set working directory
WORKDIR /tests

# Default command (will be overridden by Kubernetes)
CMD ["artillery", "--version"]