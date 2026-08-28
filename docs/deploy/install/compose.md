# Deploying with Docker Compose

Using Docker Compose is the officially recommended path for production
deployments not running on a Kubernetes cluster. Keystone provides a
starter compose recipe for launching the complete application stack
from a single command.

!!! danger

    Keystone deploys with insecure defaults that are **not** suitable for
    production. See the [Settings](../configure/api_settings.md) page for
    a complete overview of configurable options and recommended settings.

## Deployment Overview

An official compose recipe is provided below along with a table summerizing
the deployed services. The recipe assumes application settings are defined
in various `.env` files located in the same directory as the compose file.
Example content for these files is also provided. For a full list of
available API settings, see the [Settings](../configure/api_settings.md) page.

| Service     | Exposed Ports | Description                                                                    |
|-------------|---------------|--------------------------------------------------------------------------------|
| `proxy`     | `80`          | Nginx reverse proxy for routing incoming requests and terminating TLS.         |
| `web`       |               | Frontend service running the Keystone web interface.                           |
| `api`       | `8000`        | Backend API responsible for business logic and database access.                |
| `db`        |               | PostgreSQL database used for persistent application data.                      |
| `cache`     |               | Redis instance used as a caching and messaging backend for Celery components.  |
| `smtp`      | `8025`        | A mock SMTP server with a web frontend for viewing issued emails.              |
| `scheduler` |               | Celery Beat scheduler for executing periodic tasks.                            |
| `worker`    |               | Celery worker processes for background task execution (4 replicas by default). |

??? abstract "docker-compose.yml"

    ```yaml
    --8<-- "submodules/keystone-demo/demo/docker-compose.yml"
    ```

??? abstract "api.env"

    ```bash
    --8<-- "submodules/keystone-demo/demo/api.env"
    ```

??? abstract "db.env"

    ```bash
    --8<-- "submodules/keystone-demo/demo/db.env"
    ```

## Deploying the Stack

The recipe reads settings from two environment files.
The `api.env` file is used to configure settings for the Keystone API.
The `db.env` file is used to define settings for the backend postgres database.

!!! warning "Matching credentials"

    The database credentials in `api.env` and `db.env` must match exactly, or
    the API will fail to connect to the database. The `REDIS_HOST` and `DB_HOST`
    values must also match the corresponding service names in the compose file.

To launch the deployment, run the `docker compose up` command from the directory
same containing the compose recipe and `.env` files:

```sh
docker compose up -d  # Launch a new instance
```

After the application launches, create a new administrative user
by calling the `keystone-api createsuperuser` command from within
the API container:

```sh
docker exec keystone-api keystone-api createsuperuser
```

The web interface is now available at `http://localhost:80`.
Confirm the deployment by navigating to the site and authenticating with the
newly created credentials.

