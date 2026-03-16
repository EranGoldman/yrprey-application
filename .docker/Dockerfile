FROM node:20-alpine AS base
# Install dependencies only when needed
FROM base AS deps

RUN apk add --no-cache libc6-compat openssl
WORKDIR /app

# Install dependencies based on the preferred package manager
COPY ./frontend/package.json ./frontend/yarn.lock* ./frontend/package-lock.json* ./frontend/pnpm-lock.yaml* ./
RUN \
  if [ -f yarn.lock ]; then yarn --frozen-lockfile; \
  elif [ -f package-lock.json ]; then npm ci; \
  elif [ -f pnpm-lock.yaml ]; then yarn global add pnpm && pnpm i --frozen-lockfile; \
  else echo "Lockfile not found." && exit 1; \
  fi

# Rebuild the source code only when needed
FROM base AS builder

WORKDIR /app

COPY --from=deps /app/node_modules ./node_modules

COPY ./frontend .

RUN mv .env.production .env 

ENV NEXT_TELEMETRY_DISABLED=1
ENV NEXT_PRIVATE_STANDALONE=true

# Build the application
RUN yarn build



FROM ubuntu:20.04 AS app_runner

# Setup environment
ENV DEBIAN_FRONTEND=noninteractive

# Update sources
RUN apt-get update -y

# install http
RUN apt-get install -y apache2 vim bash-completion unzip
RUN mkdir -p /var/lock/apache2 /var/run/apache2

# install mysql
RUN apt-get install -y mysql-client

RUN apt-get -y install tzdata
RUN dpkg-reconfigure -f noninteractive tzdata
RUN apt-get install -y --allow-unauthenticated nginx-full
RUN apt-get install -y net-tools nano telnet
# Instalação do PHP 7.4
RUN apt-get update -y \
    && apt-get install -y software-properties-common \
    && add-apt-repository ppa:ondrej/php -y \
    && apt-get update -y \
    && apt-get install -y \
        apache2 \
        php7.4 \
        libapache2-mod-php7.4 \
        php7.4-fpm \
        php7.4-intl \
        php7.4-curl \
        php7.4-mbstring \
        php7.4-mysqli \
        php7.4-xml \
        ca-certificates \
        curl \
        gnupg

RUN apt-get install -y mariadb-server expect

# install supervisord
RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor \
    && mkdir -p /etc/apt/keyrings

RUN apt update -y 
# Instalação do Node.js versão 20
ARG version=20.0.0
RUN curl -fsSL https://nodejs.org/dist/v${version}/node-v${version}-linux-x64.tar.gz -o node.tar.gz \
    && tar -xzvf node.tar.gz -C /usr/local --strip-components=1 \
    && rm node.tar.gz

# install sshd
RUN apt-get install -y openssh-server openssh-client passwd
RUN mkdir -p /var/run/sshd
# RUN apt install gcc g++ make -y

FROM app_runner

LABEL maintainer="Carlos Carvalho <contato@carlsoocarvalho.com.br>"

RUN rm -rf /var/www/html/index.html \
    && mkdir -p /var/www/app \
    && mkdir -p /var/www/backend \
    && chown -R www-data:www-data /var/www/html \
    && chown -R www-data:www-data /var/www/app \
    && chown -R www-data:www-data /var/www/backend

#enable services
RUN a2enmod rewrite \
  &&  a2enmod php7.4 \
  && a2enmod proxy_http

RUN mkdir -p /scripts

# COPY index.html /var/www/app/index.html
COPY ./backend /var/www/backend

COPY .docker/apache.conf /etc/apache2/sites-available/000-default.conf

COPY .docker/secure_mysql.sh /scripts/secure_mysql.sh
COPY .docker/init_db.sh /scripts/init_db.sh
# COPY .docker/dump.sql /scripts/dump.sql
COPY .docker/start.sh /scripts/start.sh

RUN chmod +x /scripts/secure_mysql.sh /scripts/init_db.sh /scripts/start.sh
RUN /etc/init.d/mysql start




# RUN chown nextjs:nodejs /app/.next
# Automatically leverage output traces to reduce image size
# Automatically leverage output traces to reduce image size
COPY --from=builder  /app/.next/standalone /var/www/app/
COPY --from=builder  /app/next.config.js /var/www/app/
COPY --from=builder  /app/.next/static /var/www/app/.next/static
COPY --from=builder  /app/public /var/www/app/public
COPY --from=builder  /app/.env /var/www/app/.env

EXPOSE 80

EXPOSE 82

EXPOSE 3000


ADD .docker/supervisord.conf /etc/

CMD ["supervisord", "-n"]