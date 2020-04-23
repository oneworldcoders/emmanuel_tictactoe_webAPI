FROM heroku/heroku:16
FROM ruby:2.7

RUN apt-get update -qq \
 && apt-get install -y \
      build-essential \
      nodejs

RUN mkdir /app
WORKDIR /app


COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v 1.17.2 && bundle install

ADD ./.profile.d /app/.profile.d
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

COPY . .

CMD ["bundle","exec","rackup", "--host", "0.0.0.0", "--port", "9292"]
