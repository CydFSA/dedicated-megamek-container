### 1. Get Linux
FROM alpine:3.7

### 2. Get Java via the package manager
RUN apk update \
&& apk upgrade \
&& apk add --no-cache bash \
&& apk add --no-cache --virtual=build-dependencies unzip \
&& apk add --no-cache curl \
&& apk add --no-cache openjdk8-jre \
&& apk add --no-cache bash \
&& apk add --no-cache wget

### 3. Get Python, PIP

RUN apk add --no-cache python3 \
&& python3 -m ensurepip \
&& pip3 install --upgrade pip setuptools \
&& rm -r /usr/lib/python*/ensurepip && \
if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
rm -r /root/.cache

### Get Flask for the app
#RUN pip install --trusted-host pypi.python.org flask

####
#### OPTIONAL : 4. SET JAVA_HOME environment variable, uncomment the line below if you need it

#ENV JAVA_HOME="/usr/lib/jvm/java-1.8-openjdk"

####

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
