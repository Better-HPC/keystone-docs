# Deploying with Docker

Keystone can be deployed with as few as two containers: one running the
backend REST API, and one running the front-end web interface. In this
configuration, each container runs its portion of the Keystone stack
alongside any required dependencies (databases, caches, etc.).
This all-in-one approach lets Keystone be deployed quickly without
setting up and managing backend services. The tradeoff is reduced
performance and scalability compared to deployments where dependencies
are run independently.

The instructions below outline a minimal, two container deployment.
Teams looking for a more robust, scalable solution should see the
[Docker Compose](./compose.md) documentation.

!!! danger

    Keystone deploys with insecure defaults that are **not** suitable for
    production. See the [Settings](../configure/api_settings.md) page for 
    a complete overview of configurable options and recommended settings.

## Deploying the API

The example below runs the latest API image as a container called `keystone`
and maps application traffic to port `8000`.
[Application settings](../configure/api_settings.md) are optional, and can be
passed to the container as environmental variables.

```sh
docker run \
  --detach \
  --publish 8000:80 \
  --name keystone \
  --env SECRET_KEY="this-is-a-secure-secret"
  docker.cloudsmith.io/better-hpc/keystone/keystone-api:latest
```

The container will automatically launch minimal instances for all required
dependencies and check for existing user accounts. If no accounts are found,
an admin account is automatically created with username `admin` and password
`quickstart`. New admin credentials can also be created interactively using
the `keystone-api` command line tool inside the container:

```sh
docker exec -it keystone keystone-api createsuperuser
```

To verify the container's health, check the running container status or
query the API's health endpoint.

```sh
curl -L http://localhost:8000/health/json | jq .
```

## Deploying the Frontend

Just like the API service, the frontend is deployed as a single container
and configured using environment variables. Unlike the API container, the
frontend runs no background dependencies of its own and supports minimal
user defined settings. The only required setting is the `API_URL` variable
used to identify the API server location.

The command below runs the frontend as a container named `keystone-web`,
mapping the web interface to port `80` and directing API requests to 
`localhost:8000`.

```sh
docker run \
  --detach \
  --publish 80:80 \
  --name keystone-web \
  --env API_URL="http://localhost:8000" \
  docker.cloudsmith.io/better-hpc/keystone/keystone-web:latest
```

Once both containers are running, the web interface will be available at
`http://localhost:80`.
