### BEFORE you build image
<code>docker pull debian:buster-slim </code>  
<code>docker pull python:3.8-slim-buster</code>  


### Build image
<code> make build </code>  
will build image with tag latest 


 

### Packages

<code>
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
</code>


### test image
<code> docker run -it gdal:latest gdal_merge.py</code>   
<code> docker run -it gdal:latest gdal_translate</code>  
