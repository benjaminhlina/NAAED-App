#!/bin/bash
# Export env vars for shiny user
export POSTGRES_HOST=${POSTGRES_HOST}
export POSTGRES_USER=${POSTGRES_USER}
export POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
export POSTGRES_DB=${POSTGRES_DB}

# Start Shiny Server
exec shiny-server