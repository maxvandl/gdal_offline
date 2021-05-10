FROM gdal:latest
WORKDIR /apt
COPY apt/asp/* /apt
RUN dpkg -i *.deb && rm -rf /apt
WORKDIR /
RUN ldconfig
