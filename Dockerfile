FROM ubuntu:20.04 AS base

LABEL Name=teamredminer
LABEL Version=1
LABEL maintainer="Carlos Berroteran (cebxan)"

ARG TRM_VERSION="0.8.1.1"

WORKDIR /tmp

RUN apt update && apt install -y \
    curl \
    tar

RUN curl -OL "https://github.com/todxx/teamredminer/releases/download/${TRM_VERSION}/teamredminer-v${TRM_VERSION}-linux.tgz" \
    && tar -xf teamredminer-v${TRM_VERSION}-linux.tgz \
    && mv teamredminer-v${TRM_VERSION}-linux teamredminer

FROM cebxan/amdgpu-opencl:20.50-1234664

ENV POOL "stratum+tcp://us-east.ezil.me:5555"
ENV WALLET "0xcd14DeA4649927ff0c3a3Fd2B8d5D1858079DA15.zil1epm0936hxwuf790fztzuy8ztmm72ah20hh57xs"
ENV PASSWORD "x"
ENV WORKER "teamredminer"
ENV EXTRA_ARGS ""

COPY --from=base /tmp/teamredminer/teamredminer /usr/local/bin/teamredminer

ENTRYPOINT ./teamredminer -o ${POOL} -u ${WALLET}.${WORKER} -p ${PASSWORD} ${EXTRA_ARGS}
