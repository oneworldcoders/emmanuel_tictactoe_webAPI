FROM ruby:2.7

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v 1.17.2 && bundle install

COPY . .

CMD bundle exec rackup --host 0.0.0.0 --port $PORT
