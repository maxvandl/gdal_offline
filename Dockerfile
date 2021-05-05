FROM python:3.8-slim-buster as builder
RUN mkdir /pkg && mkdir /apt
COPY packages/* /pkg
COPY apt/builder/* /apt
WORKDIR /apt
RUN dpkg -i *.deb
WORKDIR /pkg
#ENV TZ=Europe/Minsk
#RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
#    dpkg -i *.deb && apt update && apt-get install python3 -y
ENV WEBP_VERSION 1.0.0
ENV ZSTD_VERSION 1.3.4
ENV LIBDEFLATE_VERSION 1.7
ENV LIBJPEG_TURBO_VERSION 2.0.5
ENV GEOS_VERSION 3.9.1
ENV SQLITE_VERSION 3330000
ENV SQLITE_YEAR 2020
ENV LIBTIFF_VERSION=4.2.0
ENV NGHTTP2_VERSION 1.42.0
ENV CURL_VERSION 7.73.0
ENV PROJ_VERSION 7.2.1
ENV LIBGEOTIFF_VERSION=1.6.0
ENV OPENJPEG_VERSION 2.3.1
#RUN rm -rf /var/lib/apt/lists/*
#RUN apt-get install -y --no-install-recommends  \
#    cmake build-essential wget ca-certificates unzip pkg-config \
#    zlib1g-dev libfreexl-dev libxml2-dev nasm libpng-dev ncdu python3 python3-distutils

ENV CPUS 12

# building WEBP
RUN tar xzf libwebp-${WEBP_VERSION}.tar.gz && \
    cd libwebp-${WEBP_VERSION} && \
    CFLAGS="-O2 -Wl,-S" ./configure --enable-silent-rules && \
    echo "building WEBP ${WEBP_VERSION}..." \
    make --quiet -j${CPUS} && make --quiet install && \
    cd .. && \
# building ZSTD
    tar -zxf zstd-${ZSTD_VERSION}.tar.gz \
    && cd zstd-${ZSTD_VERSION} \
    && echo "building ZSTD ${ZSTD_VERSION}..." \
    && make --quiet -j${CPUS} ZSTD_LEGACY_SUPPORT=0 CFLAGS=-O1 \
    && make --quiet install ZSTD_LEGACY_SUPPORT=0 CFLAGS=-O1  && \
    cd .. && \
# building libdeflate
    tar -zxf v${LIBDEFLATE_VERSION}.tar.gz \
    && cd libdeflate-${LIBDEFLATE_VERSION} \
    && echo "building libdeflate ${LIBDEFLATE_VERSION}..." \
    && make -j${CPUS} \
    && make --quiet install  && \
    cd .. && \
# building libjpeg-turbo
    tar -zxf ${LIBJPEG_TURBO_VERSION}.tar.gz \
    && cd libjpeg-turbo-${LIBJPEG_TURBO_VERSION} \
    && echo "building libjpeg-turbo ${LIBJPEG_TURBO_VERSION}..." \
    && cmake -G"Unix Makefiles" -DCMAKE_INSTALL_PREFIX=/usr/local/builder -DCMAKE_BUILD_TYPE=Release . \
    && make -j${CPUS} \
    && make --quiet install   && \
    cd .. && \
# building geos
    tar -xjf geos-${GEOS_VERSION}.tar.bz2  \
    && cd geos-${GEOS_VERSION} \
    && ./configure --prefix=/usr/local/builder \
    && echo "building geos ${GEOS_VERSION}..." \
    && make --quiet -j${CPUS} && make --quiet install   && \
    cd .. && \
# building SQLITE
    tar -xzf sqlite-autoconf-${SQLITE_VERSION}.tar.gz && cd sqlite-autoconf-${SQLITE_VERSION} \
    && ./configure --prefix=/usr/local/builder \
    && echo "building SQLITE ${SQLITE_VERSION}..." \
    && make --quiet -j${CPUS} && make --quiet install  && \
    cd .. && \
# building libtiff
    tar -xzf tiff-${LIBTIFF_VERSION}.tar.gz \
    && cd tiff-${LIBTIFF_VERSION} \
    && ./configure --prefix=/usr/local/builder \
    && echo "building libtiff ${LIBTIFF_VERSION}..." \
    && make --quiet -j${CPUS} && make --quiet install   && \
    cd .. && \
    tar -xzf nghttp2-${NGHTTP2_VERSION}.tar.gz \
    && cd nghttp2-${NGHTTP2_VERSION} \
    && echo "building NGHTTP2 ${NGHTTP2_VERSION}..." \
    && ./configure --enable-lib-only --prefix=/usr/local/builder \
    && make --quiet -j${CPUS} && make --quiet install   && \
    cd .. && \
    tar -xzf curl-${CURL_VERSION}.tar.gz && cd curl-${CURL_VERSION} \
    && ./configure --prefix=/usr/local/builder \
    && echo "building CURL ${CURL_VERSION}..." \
    && make --quiet -j${CPUS} && make --quiet install   && \
    cd .. && \
    tar -xzf proj-${PROJ_VERSION}.tar.gz \
    && cd proj-${PROJ_VERSION} \
    && ./configure --prefix=/usr/local/builder \
    && echo "building proj ${PROJ_VERSION}..." \
    && make --quiet -j${CPUS} && make --quiet install   && \
    cd .. && \
    tar -xzf libgeotiff-${LIBGEOTIFF_VERSION}.tar.gz \
    && cd libgeotiff-${LIBGEOTIFF_VERSION} \
    && ./configure --prefix=/usr/local/builder --with-zlib \
    && echo "building libgeotiff ${LIBGEOTIFF_VERSION}..." \
    && make --quiet -j${CPUS} && make --quiet install   && \
    cd .. && \

# ENV SPATIALITE_VERSION 5.0.0
# RUN wget -q https://www.gaia-gis.it/gaia-sins/libspatialite-${SPATIALITE_VERSION}.tar.gz
# RUN apt-get install -y libminizip-dev
# RUN tar -xzvf libspatialite-${SPATIALITE_VERSION}.tar.gz && cd libspatialite-${SPATIALITE_VERSION} \
#     && ./configure --prefix=/usr/local \
#     && echo "building SPATIALITE ${SPATIALITE_VERSION}..." \
#     && make --quiet -j${CPUS} && make --quiet install


    tar -zxf openjpeg-${OPENJPEG_VERSION}.tar.gz \
    && cd openjpeg-${OPENJPEG_VERSION} \
    && mkdir build && cd build \
    && cmake .. -DBUILD_THIRDPARTY:BOOL=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local/builder \
    && echo "building openjpeg ${OPENJPEG_VERSION}..." \
    && make --quiet -j${CPUS} && make --quiet install

ENV GDAL_SHORT_VERSION 3.1.0
ENV GDAL_VERSION 3.1.0
RUN tar -xzf gdal-${GDAL_VERSION}.tar.gz && cd gdal-${GDAL_SHORT_VERSION} && \
    ./configure \
    --prefix=/usr/local/builder \
    --with-python \
    --with-geos \
    --with-geotiff=internal \
    --with-hide-internal-symbols \
    --with-libtiff=internal \
    --with-libz=internal \
    --with-threads \
    --without-bsb \
    --without-cfitsio \
    --without-cryptopp \
    --without-curl \
    --without-dwgdirect \
    --without-ecw \
    --without-expat \
    --without-fme \
    --without-freexl \
    --without-gif \
    --without-gif \
    --without-gnm \
    --without-grass \
    --without-grib \
    --without-hdf4 \
    --without-hdf5 \
    --without-idb \
    --without-ingres \
    --without-jasper \
    --without-jp2mrsid \
    --without-jpeg \
    --without-kakadu \
    --without-libgrass \
    --without-libkml \
    --without-libtool \
    --without-mrf \
    --without-mrsid \
    --without-mysql \
    --without-netcdf \
    --without-odbc \
    --without-ogdi \
    --without-openjpeg \
    --without-pcidsk \
    --without-pcraster \
    --without-pcre \
    --without-perl \
    --without-qhull \
    --without-sde \
    --without-webp \
    --without-xerces \
    --without-xml2 \
    && echo "building GDAL ${GDAL_VERSION}..." \
    && make -j${CPUS} && make install 

RUN ldconfig && rm -rf /pkg
# https://proj.org/usage/environmentvars.html#envvar-PROJ_NETWORK
ENV PROJ_NETWORK ON

FROM ubuntu:20.04
RUN mkdir /apt
COPY apt/runner/* /apt
ENV TZ=UTC
COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /usr/local/builder /usr/local/
WORKDIR /apt
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    dpkg -i *.deb