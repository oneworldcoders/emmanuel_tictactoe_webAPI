#!/bin/bash
set -e

# bundle exec rake db:migrate

# if [[ $? != 'postgres' ]]; then
#   bundle exec rake db:setup && \
#   bundle exec rake db:migrate
# fi

exec "$@"