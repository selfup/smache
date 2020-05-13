FROM bitwalker/alpine-elixir:1.10.3 AS build

ENV VERSION=0.0.1 APP=smache MIX_ENV=prod

RUN apk --update add make bash && rm -rf /var/cache/apk/*

COPY mix.exs mix.lock LICENSE /workspace/
COPY scripts /workspace/scripts

WORKDIR /workspace

RUN /workspace/scripts/secret.sh

RUN source .env && mix do deps.get, compile

COPY config /workspace/config 
COPY lib /workspace/lib

RUN source .env && mix compile

COPY rel /workspace/rel

RUN source .env && mix release

# REMOVE SOURCE CODE
RUN rm -rf lib mix.exs mix.lock scripts

# RUNTIME STAGE
FROM alpine

EXPOSE 4000

ENV PORT=4000

RUN apk --update add bind-tools bash curl && rm -rf /var/cache/apk/*

COPY --from=build /workspace /workspace

WORKDIR /workspace

HEALTHCHECK --interval=10s --timeout=2s \
  CMD curl -f 0.0:4000/healthcheck || exit 1

CMD ["./rel/boot.sh"]
