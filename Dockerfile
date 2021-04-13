FROM bellsoft/liberica-openjdk-alpine:11.0.8-10

# install Docker
#ENV DOCKER_BUCKET="download.docker.com" \
#    DOCKER_CHANNEL="stable" \
#    DIND_COMMIT="3b5fac462d21ca164b3778647420016315289034" \
#    DOCKER_COMPOSE_VERSION="1.26.0" \
#    SRC_DIR="/usr/src"

#ENV DOCKER_SHA256="0f4336378f61ed73ed55a356ac19e46699a995f2aff34323ba5874d131548b9e"
#ENV DOCKER_VERSION="19.03.11"

# Install Docker
#RUN set -ex \
#    && curl -fSL "https://${DOCKER_BUCKET}/linux/static/${DOCKER_CHANNEL}/x86_64/docker-${DOCKER_VERSION}.tgz" -o docker.tgz \
#    && echo "${DOCKER_SHA256} *docker.tgz" | sha256sum -c - \
#    && tar --extract --file docker.tgz --strip-components 1  --directory /usr/local/bin/ \
#    && rm docker.tgz \
#    && docker -v \
#    # set up subuid/subgid so that "--userns-remap=default" works out-of-the-box
#    && addgroup dockremap \
#    && addgroup root dockremap \
#    && echo 'root:165536:65536' >> /etc/subuid \
#    && echo 'root:165536:65536' >> /etc/subgid \
#    && wget -nv "https://raw.githubusercontent.com/docker/docker/${DIND_COMMIT}/hack/dind" -O /usr/local/bin/dind
#VOLUME /var/lib/docker

# install Maven
ARG MAVEN_VERSION=3.6.3
ARG USER_HOME_DIR="/root"
RUN apk add --no-cache curl tar bash yarn && \
mkdir -p /usr/share/maven && \
curl -fsSL http://apache.osuosl.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar -xzC /usr/share/maven --strip-components=1 && \
ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"
# speed up Maven JVM a bit
ENV MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1"

# install git
#RUN apk add --no-cache bash git openssh
#
#RUN git --version

# install maven dependencies
RUN mkdir -p /usr/src/maven
WORKDIR /usr/src/maven
COPY pom.xml /usr/src/maven
RUN mvn -T 1C test install

# install yarn dependencies
ARG YB_PATH=/usr/src/yarn
RUN mkdir -p $YB_PATH
WORKDIR $YB_PATH
COPY package.json $YB_PATH
#COPY yarn.lock $YB_PATH
RUN yarn install
