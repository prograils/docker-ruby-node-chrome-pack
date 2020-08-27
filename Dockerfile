FROM ubuntu:18.04
LABEL maintainer="rkaczmarek@prograils.com"

# Update & upgrade
RUN apt-get update
RUN apt-get -y upgrade

# Install Ruby on Rails dependencies
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install build-essential zlib1g-dev libssl-dev \
  libreadline6-dev libyaml-dev git libcurl4-openssl-dev libpq-dev \
  libmysqlclient-dev libxslt-dev libsqlite3-dev libmagickwand-dev \
  imagemagick libmagickcore-dev libmagickwand-dev libpng-dev \
  libglib2.0-dev libbz2-dev libjpeg-dev checkinstall libx11-dev \
  libxext-dev libfreetype6-dev libxml2-dev python apt-utils curl \
  wget zip unzip cmake libmagic-dev tzdata xvfb libxi6 libgconf-2-4 \
  ghostscript

# Fix Ghostscript issues with PDFs
RUN wget -O /usr/local/bin/imagemagick-enable-pdf https://raw.githubusercontent.com/RobertKaczmarek/ubuntu-scripts/master/image/imagemagick-enable-pdf
RUN chmod +x /usr/local/bin/imagemagick-enable-pdf
RUN /usr/local/bin/imagemagick-enable-pdf

# Install node
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN DEBIAN_FRONTEND="noninteractive" apt install nodejs
RUN npm install -g yarn

# Install ruby
ENV RUBY_DOWNLOAD_SHA256 364b143def360bac1b74eb56ed60b1a0dca6439b00157ae11ff77d5cd2e92291
ADD https://cache.ruby-lang.org/pub/ruby/2.6/ruby-2.6.6.tar.gz /tmp/

RUN \
  cd /tmp && \
  echo "$RUBY_DOWNLOAD_SHA256 *ruby-2.6.6.tar.gz" | sha256sum -c - && \
  tar -xzf ruby-2.6.6.tar.gz && \
  cd ruby-2.6.6 && \
  ./configure && \
  make && \
  make install && \
  cd .. && \
  rm -rf ruby-2.6.6 && \
  rm -f ruby-2.6.6.tar.gz

RUN gem install bundler -v 1.17.3 --no-document

# Install Google Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub |  apt-key add -
RUN echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' |  tee /etc/apt/sources.list.d/google-chrome.list
RUN apt-get update && apt-get install -y google-chrome-stable

# Install chromedriver
RUN wget https://chromedriver.storage.googleapis.com/84.0.4147.30/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip
RUN rm -f chromedriver_linux64.zip
RUN mv chromedriver /usr/bin/chromedriver
RUN chown root:root /usr/bin/chromedriver
RUN chmod +x /usr/bin/chromedriver
