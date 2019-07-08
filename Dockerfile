# Build application raspi_home
# Peter Ramm, 03.05.2019

# Usage:
# Build image:                    > docker build -t rammpeter/raspi_home .
# Create container from image:    > docker run --name raspi_home -p3000:3000 -d rammpeter/raspi_home

#FROM   ruby:alpine
FROM    ruby:2.6.3
MAINTAINER Peter Ramm <Peter.Ramm@ottogroup.com>
ENV     TZ  Europe/Berlin
WORKDIR /opt/raspi_home
COPY    . /opt/raspi_home
RUN     cd /opt/raspi_home && rm -f Gemfile.lock && bundle install
EXPOSE  3000
CMD     /opt/raspi_home/run_webserver.sh

# HEALTHCHECK --interval=5m --timeout=3s CMD wget localhost:8080/Panorama -O - 2>/dev/null | grep "Please choose saved connection " >/dev/null || exit 1

