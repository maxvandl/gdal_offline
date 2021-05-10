FROM gdal:latest
WORKDIR /apt
#RUN mkdir /asp
COPY apt/asp/* /apt
#RUN apt update && apt install libssl-dev ca-certificates -y
RUN dpkg -i *.deb && rm -rf /apt
WORKDIR /
RUN ldconfig