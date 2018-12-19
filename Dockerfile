FROM netyazilim/alpine-base:3.8

ARG VERSION=1.5.2

WORKDIR /tmp
RUN wget --no-cache --quiet https://dl.influxdata.com/kapacitor/releases/kapacitor-${VERSION}-static_linux_amd64.tar.gz -O kapacitor.tar.gz && \
    tar xvfz kapacitor.tar.gz --strip 2 

FROM scratch

LABEL maintainer "Levent SAGIROGLU <LSagiroglu@gmail.com>"

EXPOSE 9092
ENV KAPACITOR_CONFIG_PATH /etc/kapacitor.conf
VOLUME /shared
VOLUME /var/lib/kapacitor

COPY --from=0 /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=0 /etc/localtime /etc/localtime
COPY --from=0 /etc/timezone /etc/timezone

COPY --from=0 /tmp/kapacitord /bin/kapacitord
COPY --from=0 /tmp/kapacitor.conf /etc/kapacitor.conf
ENTRYPOINT ["/bin/kapacitord"]
