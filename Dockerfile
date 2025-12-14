FROM rocker/shiny:latest

# Install system dependencies for R packages
RUN apt-get update && apt-get install -y \
    cmake \
    g++ \
    gdal-bin \
    git \
    gfortran \
    libabsl-dev \
    libcairo2-dev \
    libcurl4-openssl-dev \
    libgeos-dev \
    libgdal-dev \
    libicu-dev \
    libjpeg-dev \ 
    libmysqlclient-dev \
    libpng-dev \
    libpq-dev \
    libproj-dev \
    libsqlite3-dev \
    libssl-dev \
    libtiff5-dev \
    libudunits2-dev \
    libxml2-dev \
    libxt-dev \
    make \
    pandoc \
    proj-bin \
    proj-data \
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