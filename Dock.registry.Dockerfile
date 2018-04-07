FROM alpine:latest

WORKDIR "/opt"

ADD .docker_build/registry /opt/bin/registry

HEALTHCHECK CMD curl -fs http://localhost:$PORT/ || exit 1

CMD ["/opt/bin/registry"]
