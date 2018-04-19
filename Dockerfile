FROM bitwalker/alpine-elixir:1.6.3

EXPOSE 4000

ENV PORT=4000 VERSION=0.0.1 APP=smache MIX_ENV=prod

RUN apk --update add make bash curl curl-dev && rm -rf /var/cache/apk/*

WORKDIR ${HOME}

COPY . .

RUN source .env \
  && mix do deps.get, compile, release --verbose --env=prod

HEALTHCHECK --interval=1s --timeout=2s \
  CMD curl -f 0.0:4000/healthcheck || exit 1

CMD ["./rel/boot.sh"]
