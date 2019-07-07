# Build application raspi_home
# Peter Ramm, 03.05.2019

# Usage:
# Build image:                    > docker build -t rammpeter/raspi_home .
# Create container from image:    > docker run --name raspi_home -p3000:3000 -d rammpeter/raspi_home

FROM   ruby:alpine
MAINTAINER Peter Ramm <Peter.Ramm@ottogroup.com>

WORKDIR /opt/raspi_home
COPY    Panorama_Otto.war run_Panorama_Otto_docker.sh /opt/panorama/
#RUN     echo "Europe/Berlin" > /etc/timezone; dpkg-reconfigure -f noninteractive tzdata
EXPOSE  8080
CMD     /opt/panorama/run_Panorama_Otto_docker.sh

HEALTHCHECK --interval=5m --timeout=3s CMD wget localhost:8080/Panorama -O - 2>/dev/null | grep "Please choose saved connection " >/dev/null || exit 1

