FROM ubuntu:16.04
MAINTAINER Robert Kaczmarek <rkaczmarek@prograils.com>

# Update & upgrade
RUN apt-get update
RUN apt-get -y upgrade

# Install Ruby on Rails dependencies
RUN apt-get -y install build-essential zlib1g-dev libssl-dev \
               libreadline6-dev libyaml-dev git \
               libcurl4-openssl-dev libpq-dev libmysqlclient-dev libxslt-dev \
               libsqlite3-dev libmagickwand-dev imagemagick \
               python apt-utils curl

# Install node
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt install nodejs
RUN npm install -g yarn

# Install ruby
ENV RUBY_DOWNLOAD_SHA256 dac81822325b79c3ba9532b048c2123357d3310b2b40024202f360251d9829b1
ADD https://cache.ruby-lang.org/pub/ruby/2.5/ruby-2.5.1.tar.gz /tmp/

RUN \
  cd /tmp && \
  echo "$RUBY_DOWNLOAD_SHA256 *ruby-2.5.1.tar.gz" | sha256sum -c - && \
  tar -xzf ruby-2.5.1.tar.gz && \
  cd ruby-2.5.1 && \
  ./configure && \
  make && \
  make install && \
  cd .. && \
  rm -rf ruby-2.5.1 && \
  rm -f ruby-2.5.1.tar.gz

RUN gem install bundler -v 1.17.3 --no-document

# Install other dependencies (also missing libs for chromedriver)
RUN apt-get install -y cmake libmagic-dev tzdata xvfb libxi6 libgconf-2-4

# Install Google Chrome
RUN apt-get install -y wget
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub |  apt-key add -
RUN echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' |  tee /etc/apt/sources.list.d/google-chrome.list
RUN apt-get update && apt-get install -y google-chrome-stable

# Install chromedriver
RUN apt-get install -y zip unzip
RUN wget https://chromedriver.storage.googleapis.com/2.9/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip
RUN rm -f chromedriver_linux64.zip
RUN mv chromedriver /usr/bin/chromedriver
RUN chown root:root /usr/bin/chromedriver
RUN chmod +x /usr/bin/chromedriver
