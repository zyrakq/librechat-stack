FROM ghcr.io/danny-avila/librechat:latest

# Switch to root to install packages
USER root

# Install dependencies for YAML processing and environment variables
RUN apk add --no-cache \
    bash \
    curl \
    gettext \
    jq

# Install gomplate
RUN curl -o /usr/local/bin/gomplate -sSL https://github.com/hairyhenderson/gomplate/releases/latest/download/gomplate_linux-amd64 && \
    chmod +x /usr/local/bin/gomplate

# Copy scripts and templates
COPY scripts/ /usr/local/bin/
COPY templates/ /app/templates/

# Set execution permissions for scripts
RUN chmod +x /usr/local/bin/*.sh

# Set proper ownership and permissions for scripts
RUN chown -R node:node /usr/local/bin/ && \
    chmod 755 /usr/local/bin/*.sh

RUN mkdir -p /app/uploads /app/logs && \
    chown -R node:node /app && \
    chmod -R 755 /app/uploads /app/logs

# Switch back to node user for security
USER node

# New entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]