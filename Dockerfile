FROM ruby:2.7

RUN mkdir /app
WORKDIR /app

ADD Gemfile Gemfile.lock /app/
RUN gem install bundler -v 1.17.2 && bundle install

ADD . /app
CMD ["bundle","exec","rackup"]