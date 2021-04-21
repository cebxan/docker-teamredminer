FROM ubuntu:20.04 AS base

LABEL Name=teamredminer
LABEL maintainer="Carlos Berroteran (cebxan)"

ARG TRM_VERSION="0.8.1.1"

WORKDIR /tmp

RUN apt update && apt install -y \
    curl \
    tar

RUN curl -OL "https://github.com/todxx/teamredminer/releases/download/${TRM_VERSION}/teamredminer-v${TRM_VERSION}-linux.tgz" \
    && tar -xf teamredminer-v${TRM_VERSION}-linux.tgz \
    && mv teamredminer-v${TRM_VERSION}-linux teamredminer

FROM cebxan/amdgpu-opencl:21.10-1247438

COPY --from=base /tmp/teamredminer/teamredminer /usr/local/bin/teamredminer
EXPOSE 4028

ENTRYPOINT ["teamredminer"]
