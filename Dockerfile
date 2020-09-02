# Modified from: https://juanitorduz.github.io/dockerize-a-shinyapp/
# Added: install shiny server new package https://stackoverflow.com/questions/52377910/how-to-find-shiny-server-executable-and-reference-it-in-shiny-server-sh
# https://stackoverflow.com/questions/57421577/how-to-run-r-shiny-app-in-docker-container
# Used: https://www.statworx.com/de/blog/how-to-dockerize-shinyapps/
# Configuration setup from: https://github.com/kwhitehall/Shiny_app_Azure/blob/master/Dockerfile

FROM rocker/shiny:latest

# system libraries of general use -> Ubuntu packages
RUN apt-get update && apt-get install -y \
    sudo \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev

## update system libraries
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean && \ 
    sudo apt-get install -y cron && \
    sudo cron start

COPY LFDREmpiricalBayesApp.Rproj /srv/shiny-server/
COPY ui.R /srv/shiny-server/
COPY server.R /srv/shiny-server/
COPY R /srv/shiny-server/R
COPY www /srv/shiny-server/R


# install renv & restore packages
RUN Rscript -e 'install.packages("renv")'
RUN Rscript -e 'install.packages(c("shiny","shinyBS","matrixStats"))'
RUN Rscript -e 'renv::restore()'

# Port 
EXPOSE 3838

# Copy further configuration files into the Docker image
COPY shiny-server.sh /usr/bin/shiny-server.sh

RUN ["chmod", "+x", "/usr/bin/shiny-server.sh"]

CMD ["/usr/bin/shiny-server.sh"]