
SHELL = /bin/bash
TAG ?= latest

WEBP_VERSION = 1.0.0
ZSTD_VERSION = 1.3.4
LIBDEFLATE_VERSION = 1.7
LIBJPEG_TURBO_VERSION = 2.0.5
GEOS_VERSION = 3.9.1
SQLITE_VERSION = 3330000
SQLITE_YEAR = 2020
LIBTIFF_VERSION=4.2.0
NGHTTP2_VERSION = 1.42.0
CURL_VERSION = 7.73.0
PROJ_VERSION = 7.2.1
LIBGEOTIFF_VERSION = 1.6.0
OPENJPEG_VERSION = 2.3.1
GDAL_SHORT_VERSION = 3.1.0
GDAL_VERSION = 3.1.0


all: build

build:
	docker build --tag gdal:$(TAG) --file Dockerfile .

shell: build
	docker run --rm -it \
		--volume $(shell pwd)/:/app \
		gdal:$(TAG) \
		/bin/bash

infra:
	wget -P packages https://download.osgeo.org/gdal/${GDAL_SHORT_VERSION}/gdal-${GDAL_VERSION}.tar.gz
	wget https://github.com/uclouvain/openjpeg/archive/v${OPENJPEG_VERSION}.tar.gz -O packages/openjpeg-${OPENJPEG_VERSION}.tar.gz 
	wget -P packages https://github.com/OSGeo/libgeotiff/releases/download/${LIBGEOTIFF_VERSION}/libgeotiff-${LIBGEOTIFF_VERSION}.tar.gz
	wget -P packages https://download.osgeo.org/proj/proj-${PROJ_VERSION}.tar.gz
	wget -P packages https://curl.haxx.se/download/curl-${CURL_VERSION}.tar.gz
	wget -P packages https://github.com/nghttp2/nghttp2/releases/download/v${NGHTTP2_VERSION}/nghttp2-${NGHTTP2_VERSION}.tar.gz
	wget -P packages https://download.osgeo.org/libtiff/tiff-${LIBTIFF_VERSION}.tar.gz
	wget -P packages https://sqlite.org/${SQLITE_YEAR}/sqlite-autoconf-${SQLITE_VERSION}.tar.gz
	wget -P packages https://download.osgeo.org/geos/geos-${GEOS_VERSION}.tar.bz2
	wget -P packages https://github.com/libjpeg-turbo/libjpeg-turbo/archive/${LIBJPEG_TURBO_VERSION}.tar.gz
	wget -P packages https://github.com/ebiggers/libdeflate/archive/v${LIBDEFLATE_VERSION}.tar.gz 
	wget https://github.com/facebook/zstd/archive/v${ZSTD_VERSION}.tar.gz -O packages/zstd-${ZSTD_VERSION}.tar.gz
	wget -P packages https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-${WEBP_VERSION}.tar.gz
    docker pull python:3.8-slim-buster
	docker pull ubuntu:20.04
