FROM ubuntu:20.04

RUN apt-get update && apt-get install --no-install-recommends -y \
    python3.8 \
    python-is-python3 \
    python3-pip \
    openjdk-8-jre-headless \
    wget \
	unzip \
	nano

# prepare home, user for megamek
ENV MEGAMEK_HOME /megamek

ARG user=megamek
ARG uid=99
ARG gid=100

RUN useradd -d "$MEGAMEK_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

# RUN wget -q https://github.com/seem8/astech/archive/refs/heads/master.zip && unzip master.zip -d /megamek

RUN wget -qO- https://github.com/MegaMek/megamek/releases/download/v0.48.0/megamek-0.48.0.tar.gz \
  | tar -xzf - --strip-components=1 -C /megamek

WORKDIR /megamek


EXPOSE 2346
# EXPOSE 8080

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
