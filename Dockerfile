FROM ubuntu:latest AS builder

RUN apt-get update
RUN apt-get install software-properties-common -y
RUN add-apt-repository ppa:gluster/glusterfs-9 -y
RUN apt-get purge software-properties-common -y
RUN apt-get autoremove -y
RUN apt-get install --download-only glusterfs-server -y

FROM ubuntu:latest

RUN apt-get update
COPY --from=builder /var/cache/apt/archives/* /var/cache/apt/archives/
RUN apt-get install glusterfs-server -y \
    && apt-get install -f \
    && rm -rf /var/cache /var/lib/{apt,dpkg,cache,log}

USER root
EXPOSE 24007
ENTRYPOINT [ "/usr/sbin/glusterd" ]
MAINTAINER 'Byeonghoon Isac Yoo <bh322yoo@gmail.com>
CMD [ "--no-daemon", "-p", "/var/run/glusterd.pid", "--log-level", "DEBUG" ]