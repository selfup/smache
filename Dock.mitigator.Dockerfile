FROM alpine:latest

WORKDIR "/opt"

ADD .docker_build/mitigator /opt/bin/mitigator

HEALTHCHECK CMD curl -fs http://localhost:$PORT/ || exit 1

CMD ["/opt/bin/mitigator"]
