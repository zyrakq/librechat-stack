#!/bin/sh
set -e

echo "Starting LibreChat with dynamic configuration..."

# Set default values for required variables
export LIBRECHAT_VERSION="${LIBRECHAT_VERSION:-1.2.1}"

echo "Building LibreChat configuration from environment variables..."
/usr/local/bin/build-config.sh

mkdir -p api/data

echo '{}' > api/data/auth.json

echo "Starting LibreChat application..."
cd /app
exec npm run backend