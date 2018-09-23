FROM bitwalker/alpine-elixir:1.7.3 AS build

ENV VERSION=0.0.1 APP=smache MIX_ENV=prod

RUN apk --update add make bash && rm -rf /var/cache/apk/*

COPY . /workspace

WORKDIR /workspace

RUN source .env \
  && mix do deps.get, compile, release --verbose --no-tar --env=prod

# REMOVE SOURCE CODE
RUN rm -rf lib mix.exs mix.lock

# RUNTIME STAGE
FROM bitwalker/alpine-elixir:1.7.3

EXPOSE 4000

ENV PORT=4000

RUN apk --update add bind-tools bash curl && rm -rf /var/cache/apk/*

COPY --from=build /workspace /workspace

WORKDIR /workspace

HEALTHCHECK --interval=10s --timeout=2s \
  CMD curl -f 0.0:4000/healthcheck || exit 1

CMD ["./rel/boot.sh"]
