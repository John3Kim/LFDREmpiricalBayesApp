#!/bin/sh

# Source: https://github.com/kwhitehall/Shiny_app_Azure/blob/master/shiny-server.sh
# Make sure the directory for individual app logs exists
mkdir -p /var/log/shiny-server
chown shiny.shiny /var/log/shiny-server

exec shiny-server >> /var/log/shiny-server.log 2>&1