FROM hexpm/elixir:1.17.3-erlang-25.3.2.17-alpine-3.18.9 AS build

ENV VERSION=0.0.1 APP=smache MIX_ENV=prod
ENV SECRET_KEY_BASE=${SECRET_KEY_BASE}
ENV PHX_SERVER=true

RUN apk --update add make bash --no-cache

COPY mix.exs mix.lock LICENSE /workspace/
COPY scripts /workspace/scripts

WORKDIR /workspace

RUN scripts/secret.sh

RUN source .env && mix do deps.get --only prod, deps.compile

COPY config /workspace/config 
COPY lib /workspace/lib

RUN source .env && mix compile

COPY rel /workspace/rel

RUN source .env && mix release

# REMOVE SOURCE CODE
RUN rm -rf lib mix.exs mix.lock scripts .env

# RUNTIME STAGE
FROM alpine:3.18.9

ENV PORT=4000
ENV COOKIE=${COOKIE}
EXPOSE 4000
ENV PHX_SERVER=true
ENV PHX_HOST="localhost"

RUN apk --update add make bash bind-tools curl openssl libgcc ncurses-libs libstdc++ --no-cache

RUN rm -rf /var/cache/apk/*

COPY --from=build /workspace /workspace

WORKDIR /workspace

HEALTHCHECK --interval=10s --timeout=2s --start-period=30s \
  CMD curl -f 0.0:4000/healthcheck || exit 1

CMD ["./rel/boot.sh"]
