# Ruby on Rails Development Image
This image is used for developing in Ruby on Rails without any host installation of Ruby.

Ruby and Bundler environment variables are configured in the image to ensure all gems are installed in the project directory itself rather than somewhere else in the container. This effectively provides a local gem cache so you can move from the kickstart, to a manual server, to a ```docker compose``` managed server, without having to re-install gems.

## To kickstart a new rails application
``` shell
mkdir myapp; cd myapp
docker run -it --rm -v $PWD:/src --name rails-kick goclearsky/rails kickstart
```
Change ```kickstart``` to ```kickboot``` or ```kicktail``` if you want bootstrap or tailwind installed with esbuild.

Known shortcomings in the installation process are automatically resolved using ```patch``` where possible (see bin/kickboot).

Once the kickstart process is complete, the image will shutdown and remove itself.

## To run the rails server manually
``` shell
docker run -it --rm -v $PWD:/src --name rails-serv -p 3000:3000 -e RAILS_DEVELOPMENT_HOSTS=mynode.mydomain.net goclearsky/rails server
```
Change ```mynode.mydomain.net``` to your hostname, or however you will refer to your app from your browser.

## To run the rails server via docker compose
``` docker-compose.yaml
rails-myapp:                     # <-- name of service
  container_name: rails-myapp    # <-- name of container
  image: goclearsky/rails
  ports:
    - "3000:3000"                # <-- dev ports
  volumes:
    - /full/path/to/myapp:/src   # <-- path to application dir
  environment:
    RAILS_DEVELOPMENT_HOSTS: mynode.mydomain.net
```
Service name is used if you need to connect w/ other containers. Container name is used below to gain shell access to the container.
Keeping these the same is not required, just simpler.

## To start the container using compose configuration above
``` shell
docker-compose up -d rails-myapp
```

## To get a shell in the running container
``` shell
docker exec -it rails-myapp /bin/bash
```

## To run a second rails app via docker compose
``` docker-compose.yaml
rails-myapp2:                    # <-- name of service
  container_name: rails-myapp2   # <-- name of container
  image: goclearsky/rails
  ports:
    - "3001:3000"                # <-- dev ports
  volumes:
    - /full/path/to/myapp2:/src  # <-- path to application dir
  environment:
    RAILS_DEVELOPMENT_HOSTS: mynode.mydomain.net
```
Copy the first and update the service name, the container name, and the path. Then expose the app on a different port (internal port remains the default 3000).
