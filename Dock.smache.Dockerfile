FROM bitwalker/alpine-elixir:1.6.3

EXPOSE 4000

ENV PORT=4000 \
  VERSION=0.0.1 \
  APP=smache \
  REPLACE_OS_VARS=true \
  MIX_ENV=prod

RUN apk --update add make bash && rm -rf /var/cache/apk/*

WORKDIR ${HOME}

COPY . .

RUN source .env \
  && mix do deps.get, compile, release --verbose --env=prod

# WORKDIR /opt/$APP

HEALTHCHECK --interval=15s --timeout=5s \
  CMD curl -f "http://0.0:$PORT/healthcheck" || exit 1

CMD bash -c "elixir rel/vm_args.exs && _build/prod/rel/smache/bin/smache foreground"
