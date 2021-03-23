FROM openjdk:8-jdk

LABEL version="0.48.0"

# Install some bits
RUN apt-get update && apt-get install --no-install-recommends -y wget tar python3.6 && apt-get clean all

# prepare home, user for megamek
ENV MEGAMEK_HOME /megamek

ARG user=megamek
ARG group=megamek
ARG uid=99
ARG gid=100

# RUN groupadd -g ${gid} ${group} \
#    && useradd -d "$MEGAMEK_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

RUN useradd -d "$MEGAMEK_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

RUN wget -qO- https://github.com/seem8/astech/archive/refs/heads/master.zip \
  | tar -xzf - -C /megamek

RUN wget -qO- https://github.com/MegaMek/megamek/releases/download/v0.46.1/megamek-0.48.0.tar.gz \
  | tar -xzf - --strip-components=1 -C /megamek

WORKDIR /megamek

# expose ssh port
EXPOSE 2346

# make sure host keys are regenerated before sshd starts
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
