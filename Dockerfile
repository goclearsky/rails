# Ruby on Rails image
FROM ruby
MAINTAINER miketallroth

WORKDIR /src

# use application directory as a bundle cache (rather than storing inside container)
ENV GEM_HOME /src/.bundle
ENV BUNDLE_PATH $GEM_HOME
ENV BUNDLE_BIN $BUNDLE_PATH/bin
ENV BUNDLE_APP_CONFIG="$GEM_HOME"
ENV BUNDLE_SILENCE_ROOT_WARNING=0
ENV PATH $BUNDLE_BIN:$PATH

# set not root user and perms
ARG UID=1000
ARG GID=1000
RUN groupadd -g "${GID}" ruby \
 && useradd --create-home --no-log-init -u "${UID}" -g "${GID}" ruby

# update os, install supporting utils
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y nodejs npm sqlite3 vim \
 && apt-get autoremove \
 && npm install -g npx yarn

# setup entrypoint dispatcher - not all versions have patches
COPY ./bin/docker-entrypoint /usr/bin/docker-entrypoint
COPY ./bin/kickstart/kickstart-nobias /usr/bin/kickstart-nobias
COPY ./bin/kickstart/patch* /usr/bin/kickstart/
COPY ./bin/kickboot/kickstart-bootstrap /usr/bin/kickstart-bootstrap
COPY ./bin/kickboot/patch* /usr/bin/kickboot/
COPY ./bin/kicktail/kickstart-tailwind /usr/bin/kickstart-tailwind
COPY ./bin/kicktail/patch* /usr/bin/kicktail/
RUN chmod a+x /usr/bin/docker-entrypoint
RUN chmod a+x /usr/bin/kickstart-*

USER ruby

# call dispatcher
ENTRYPOINT ["/usr/bin/docker-entrypoint"]

# command arg passed to entrypoint
# server is default, but can also be kickstart, kickboot, kicktail, or bash
CMD ["server"]
