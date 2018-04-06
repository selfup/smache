FROM alpine:latest

WORKDIR "/opt"

ADD .docker_build/mitigator /opt/bin/mitigator

CMD ["/opt/bin/mitigator"]
