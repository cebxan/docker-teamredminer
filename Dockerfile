FROM ubuntu:20.04 AS base

LABEL Name=teamredminer
LABEL maintainer="Carlos Berroteran (cebxan)"

ARG TRM_VERSION="0.8.2"

WORKDIR /tmp

RUN apt update && apt install -y \
    curl \
    tar

RUN curl -OL "https://github.com/todxx/teamredminer/releases/download/${TRM_VERSION}/teamredminer-v${TRM_VERSION}-linux.tgz" \
    && tar -xf teamredminer-v${TRM_VERSION}-linux.tgz \
    && mv teamredminer-v${TRM_VERSION}-linux teamredminer

FROM cebxan/amdgpu-opencl:21.10-1247438-2

RUN apt update && apt install -y \
    netcat \
    jq \
    && rm -rf /var/lib/apt/lists/*

COPY --from=base /tmp/teamredminer/teamredminer /usr/local/bin/teamredminer
EXPOSE 4028

HEALTHCHECK --interval=30s --timeout=30s --start-period=60s --retries=3 CMD \
    echo '{"command":"summary"}' | nc localhost 4028 | jq -e 'any(.STATUS[0];.STATUS=="S")' || exit 1

ENTRYPOINT ["teamredminer"]
