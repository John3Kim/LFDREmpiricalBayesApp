# Modified from: https://juanitorduz.github.io/dockerize-a-shinyapp/
# Added: install shiny server new package https://stackoverflow.com/questions/52377910/how-to-find-shiny-server-executable-and-reference-it-in-shiny-server-sh
# https://stackoverflow.com/questions/57421577/how-to-run-r-shiny-app-in-docker-container
# Used: https://www.statworx.com/de/blog/how-to-dockerize-shinyapps/
FROM rocker/shiny-verse:latest

# system libraries of general use
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
    apt-get clean

COPY LFDREmpiricalBayesApp.Rproj /srv/shiny-server/
#COPY .gitignore /srv/shiny-server/
#COPY .Rapp.history /srv/shiny-server/
COPY LICENSE /srv/shiny-server/
COPY README.md /srv/shiny-server/
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

# allow permission
#RUN sudo chown -R shiny:shiny /srv/rshiny
RUN sudo chmod -R 755 /srv/shiny-server

# run app
CMD ["R", "-e", "shiny::runApp('/srv/shiny-server/', host = '0.0.0.0', port = 3838)"]

# Make container with: docker run --rm -p 3838:3838 lfdrempiricalbayes
#Explore file system
#docker run -it --rm lfdrempiricalbayes bash 