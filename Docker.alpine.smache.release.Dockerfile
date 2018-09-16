FROM alpine:latest

EXPOSE 4000

ENV PORT=4000 VERSION=0.0.1 APP=smache MIX_ENV=prod

RUN apk --update add make bash curl curl-dev && rm -rf /var/cache/apk/*

WORKDIR ${HOME}

COPY .env .
COPY ./smache:*.tar.gz .

RUN source .env && tar -xzf smache:*.tar.gz

HEALTHCHECK --interval=10s --timeout=2s \
  CMD curl -f 0.0:4000/healthcheck || exit 1

CMD ["./rel/boot.sh"]
