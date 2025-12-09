FROM rocker/shiny:latest

# Install system dependencies for R packages
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libpq-dev \
    libpq5 \
    libudunits2-dev \
    libgdal-dev \
    libgeos-dev \
    libproj-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install R packages
RUN R -e "install.packages(c( \
    'codetools', \
    'curl', \
    'DBI', \
    'dplyr', \
    'DT', \
    'gert', \
    'ggplot2', \
    'ggtext', \
    'gh', \
    'here', \
    'httr2', \
    'leaflet', \
    'mapview', \
    'openssl', \
    'plotly', \
    'Rcpp', \
    'readr', \
    'RPostgres', \
    'RPostgreSQL', \
    'sf', \
    'shiny', \
    'shinydashboard', \
    'shinyjs', \
    'shinymanager' \
  ), repos='https://cran.rstudio.com/')"

# Copy app files
COPY app.R /srv/shiny-server/
COPY www /srv/shiny-server/www
COPY data /srv/shiny-server/data
COPY modules /srv/shiny-server/modules

# Expose port
EXPOSE 3838

# Run app
CMD ["/usr/bin/shiny-server"]