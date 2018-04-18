#!/usr/bin/env bash

# pass in the app name as the first argument
# ex: ./scripts/heroku.sh my_cool_app_name

# assumes you are logged into heroku cli
# assumes you are logged into heroku container registry
# assumes you have an app name

./scripts/secret.sh \
  && echo '--->' \
  && echo 'HEROKU BUILD/DEPLOY' \
  && echo '--->' \
  && heroku container:push web --app $1
