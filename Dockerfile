# Ruby on Rails image
#
# to build the image
#   docker build -t rails .
#
# to generate a new application, select myapp as desired,
#   mkdir myapp; cd myapp
#   docker run -it --rm -v $PWD:/src --name rails-kick rails kick* (boot or tail)
#
# to run the rails server,
#   docker run -it --rm -v $PWD:/src --name rails-serv -p 3000:3000 -e RAILS_DEVELOPMENT_HOSTS=mynode.mydomain.net rails server
#
# to run in docker compose with default CMD (server)
#   rails-myapp:                     <-- name of service
#     container_name: rails-myapp    <-- name of container
#     image: rails                   <-- name of image built above
#     ports:
#       - "3000:3000"                <-- dev ports
#     volumes:
#       - /full/path/to/myapp:/src   <-- path to application dir
#     environment:
#       RAILS_DEVELOPMENT_HOSTS: mynode.mydomain.net
#
#   Name of service is used if you need to connect w/ other containers.
#   Name of container is used below to gain shell access to the container.
#   Keeping them the same is not required, just simpler.
#   Run a separate container for a different app,
#     change name of service, container, ext port, and path in volume.
# 
# to start the container using compose configuration above
#   docker-compose up -d rails-myapp
#
# to get a shell in the running container
#   docker exec -it rails-myapp /bin/bash
#
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

# setup entrypoint dispatcher
COPY ./bin/docker-entrypoint /usr/bin/docker-entrypoint
COPY ./bin/kickboot/kickstart-bootstrap /usr/bin/kickstart-bootstrap
COPY ./bin/kickboot/patch* /usr/bin/kickboot/
COPY ./bin/kicktail/kickstart-tailwind /usr/bin/kickstart-tailwind
COPY ./bin/kicktail/patch* /usr/bin/kicktail/
RUN chmod a+x /usr/bin/docker-entrypoint
RUN chmod a+x /usr/bin/kickstart-bootstrap
RUN chmod a+x /usr/bin/kickstart-tailwind

USER ruby

# call dispatcher
ENTRYPOINT ["/usr/bin/docker-entrypoint"]

# command arg passed to entrypoint
# server is default, but can also be kickboot, kicktail, bash
CMD ["server"]
