FROM centos:centos7.3.1611
MAINTAINER Cizel<cizelme@cizel.cn>

# set env
ENV NGINX_VERSION 1.9.5
ENV PHALCON_VERSION 2.0.8
ENV IGBINARY_VERSION 1.2.1
ENV REDIS_VERSION 4.0.0

# install base tool
RUN yum update -y && yum install -y \
vim \
wget \
git \ 
gcc \
gcc-c++ \
make \
automake \
autoconf \
libtool \
libxml2-devel \
libxslt-devel \ 
perl-devel \
perl-ExtUtils-Embed \
pcre-devel \
perl \ 
file \
tar \
bzip2-devel \
bzip2 \ 
openssl \
openssl-devel \
zlib \
zlib-devel \ 
re2c \ 
libjpeg \
libpng \ 
libjpeg-devel \
libpng-devel \
libjpeg-turbo \
freetype \
freetype-devel \
libcurl-devel \
libxml2-devel \
libjpeg-turbo-devel \
libXpm-devel \
libXpm \
libicu-devel \
libmcrypt \
libmcrypt-devel \
libxslt-devel \
libxslt \
openssl \
openssl-devel \
bzip2-devel

# install nginx

## download nginx modules
WORKDIR /tmp
RUN wget http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz && \
tar -xzvf nginx-$NGINX_VERSION.tar.gz -C /usr/local/src && \
wget https://ftp.pcre.org/pub/pcre/pcre-8.37.tar.gz && \
tar -xzvf pcre-8.37.tar.gz -C /usr/local/src && \
wget https://github.com/FRiCKLE/ngx_cache_purge/archive/2.3.tar.gz && \
tar -xzvf 2.3.tar.gz -C /usr/local/src && \
wget https://github.com/alibaba/nginx-http-concat/archive/1.2.2.tar.gz && \
tar -xzvf 1.2.2.tar.gz -C /usr/local/src && \
wget https://github.com/openresty/echo-nginx-module/archive/v0.58.tar.gz && \
tar -xzvf v0.58.tar.gz -C /usr/local/src && \
wget https://github.com/simplresty/ngx_devel_kit/archive/v0.2.19.tar.gz && \
tar -xzvf v0.2.19.tar.gz -C /usr/local/src && \
wget https://github.com/openresty/set-misc-nginx-module/archive/v0.29.tar.gz && \
tar -xzvf v0.29.tar.gz -C /usr/local/src && \
wget https://github.com/thomsonreuters/nginx-sticky-module-ng/archive/1.2.6.tar.gz && \
tar -xzvf 1.2.6.tar.gz -C /usr/local/src

# mkdir apps path
RUN mkdir -p /apps/srv && \ 
mkdir -p /apps/srv/logs

## nginx config 
WORKDIR /usr/local/src/nginx-$NGINX_VERSION
RUN ./configure \
--with-cc-opt=-Wno-error \
--with-ld-opt=-lstdc++ \
--prefix=/apps/srv/nginx \
--with-http_realip_module \
--with-http_gunzip_module \
--with-http_flv_module \ 
--with-http_gzip_static_module \
--with-pcre=/usr/local/src/pcre-8.37 \
--with-http_ssl_module \
--with-http_realip_module \ 
--with-http_addition_module \
--with-http_sub_module \
--with-http_auth_request_module \
--with-http_v2_module \
--with-http_stub_status_module \ 
--with-stream \
--add-module=/usr/local/src/ngx_cache_purge-2.3  \
--add-module=/usr/local/src/nginx-http-concat-1.2.2 \
--add-module=/usr/local/src/echo-nginx-module-0.58 \
--add-module=/usr/local/src/ngx_devel_kit-0.2.19 \
--add-module=/usr/local/src/set-misc-nginx-module-0.29 \
#--add-module=/usr/local/src/dna-nginx-module
--add-module=/usr/local/src/nginx-sticky-module-ng-1.2.6 && \
make && \
make install

# install php
WORKDIR /tmp
RUN wget ftp://mcrypt.hellug.gr/pub/crypto/mcrypt/attic/libmcrypt/libmcrypt-2.5.7.tar.gz && \
tar -zxvf libmcrypt-2.5.7.tar.gz && \
cd libmcrypt-2.5.7 && \
./configure && \
make && \
make install

WORKDIR /tmp
RUN yum -y install openldap openldap-devel && \
cp -frp /usr/lib64/libldap* /usr/lib/

WORKDIR /tmp
RUN wget http://php.net/get/php-5.6.20.tar.gz/from/this/mirror -O php-5.6.20.tar.gz && \
tar -zxvf php-5.6.20.tar.gz

WORKDIR /tmp/php-5.6.20
RUN ./configure \
       --prefix=/apps/srv/php56 \
       --with-config-file-path=/apps/srv/php56/etc/ \
       --with-config-file-scan-dir=/apps/srv/php56/conf.d/ \
       --enable-fpm \
       --enable-cgi \
      # --with-fpm-user=nginx  \
     # --with-fpm-group=nginx \
       --disable-phpdbg \
       --enable-mbstring \
       --enable-calendar \
       --with-xsl \
       --with-openssl \
       --enable-soap \
       --enable-zip \
       --enable-shmop \
       --enable-sockets \
       --with-gd \
       --with-freetype-dir=/usr/include/freetype2/freetype \
       --with-jpeg-dir \
       --with-png-dir \
       --with-xpm-dir \
       --with-xmlrpc \
       --enable-pcntl \
       --enable-intl \
       --with-mcrypt \
       --enable-sysvsem \
       --enable-sysvshm \
       --enable-sysvmsg \
       --enable-opcache \
       --with-iconv \
       --with-bz2 \
       --with-curl \
       --enable-mysqlnd \
       --with-mysqli=mysqlnd \
       --with-pdo-mysql=mysqlnd \
       --with-zlib \
       --with-gettext \
#       --with-ldap \
&& make \
&& make install

## php redis
WORKDIR /tmp
RUN wget https://github.com/phpredis/phpredis/archive/$REDIS_VERSION.tar.gz \
         && tar -zxvf $REDIS_VERSION.tar.gz \
         && cd phpredis-$REDIS_VERSION \
         && /apps/srv/php56/bin/phpize \
         && ./configure --with-php-config=/apps/srv/php56/bin/php-config \
         && make \
         && make install

## php igbinary
WORKDIR /tmp
RUN wget https://github.com/igbinary/igbinary/archive/$IGBINARY_VERSION.tar.gz \
         && tar -zxvf $IGBINARY_VERSION.tar.gz \
         && cd igbinary-$IGBINARY_VERSION \
         && /apps/srv/php56/bin/phpize \
         && ./configure --with-php-config=/apps/srv/php56/bin/php-config \
         && make \
         && make install

## php phalcon 
WORKDIR /tmp
RUN wget https://github.com/phalcon/cphalcon/archive/phalcon-v$PHALCON_VERSION.tar.gz \
         && tar -zxvf phalcon-v$PHALCON_VERSION.tar.gz \
         && cd cphalcon-phalcon-v$PHALCON_VERSION/build/64bits \
         && /apps/srv/php56/bin/phpize \
         && ./configure --with-php-config=/apps/srv/php56/bin/php-config --enable-phalcon \
         && make \
         && make install

# 加入环境
RUN echo "export PATH=/apps/srv/php56/bin:/apps/srv/php56/sbin:$PATH" >> ~/.bashrc \
        && source ~/.bashrc

# install supervisor
RUN yum install -y python-setuptools && \
easy_install supervisor

WORKDIR /tmp

CMD ["supervisord", "-n"]

EXPOSE 22 80 443 9000
