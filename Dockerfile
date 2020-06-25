# building customised docker image to use R Shiny Server

FROM rocker/shiny:latest

LABEL maintainer='vladimir.zhbanko@gmail.com'

## create directories
RUN mkdir -p /01_data
RUN mkdir -p /02_code
RUN mkdir -p /03_output

## copy files
# Additional packages
COPY 02_code/install_packages.R /install_packages.R

# Copy Shiny App files to the image
COPY testapp/app.R /srv/shiny-server/shinyapps/testapp/

# Copy Other Apps if needed 
# COPY testapp1/* /srv/shiny-server/shinyapps/testapp1/

## install packages 
RUN Rscript /install_packages.R

# select port
EXPOSE 3838

# allow permission
#RUN sudo chown -R shiny:shiny /srv/shiny-server

# Add shiny user
RUN groupadd  owner \
&& useradd --gid owner --shell /bin/bash --create-home owner

# run app
CMD ["/usr/bin/shiny-server.sh"]

#to run shiny server with demo capabilities
#docker run --rm -v /Users/vladdsm/shinyapps/:/srv/shiny-server -v /Users/vladdsm/shinylog/:/var/log/shiny-server -p 3838:3838 vladdsm/docker-shiny

