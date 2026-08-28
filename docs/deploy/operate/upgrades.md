# Upgrades &amp; Maintenance

Applying a new Keystone version follows the same principle regardless of how its
deployed: take the application offline, back up the database, apply the update,
and bring services back up. The exact commands differ between deployment methods,
but the order of operations is always the same.

!!! danger

    Application upgrades may involve irreversible database migrations.
    Always ensure the application database is backed up before applying updates.

## Before you upgrade

Software updates should always be applied with the application offline to prevent
inadvertent restarts or partial writes during a migration.

The general sequence is:

1. Stop any the upstream proxy so no new requests reach the application.
2. Stop the application services (web server, api server, background tasks, etc.).
3. **Back up the application database.**
4. Upgrade application packages and run database migrations.
5. Restart the application services, then the proxy.
6. Verify [application health checks](monitoring.md#system-health) to ensure all services are healthy

## Systemd deployments

Software updates are executed using the `pipx` package manager. 
The service names below match the unit files defined on the [Systemd deployment](../install/systemd.md) page.

```bash
# Stop existing services
systemctl stop nginx
systemctl stop keystone-server
systemctl stop keystone-beat
systemctl stop keystone-worker

# Pause here to back up the application database

# Apply the upgrade
pipx upgrade keystone-api
keystone-api migrate
keystone-api collectstatic

# Bring service back online
systemctl start keystone-worker
systemctl start keystone-beat
systemctl start keystone-server
systemctl start nginx
```

## Docker deployments

For Docker Compose deployments, pull the updated image and recreate the services.
The API docker container will automatically apply any pending database migrations.
This means the application database must be ready to receive connections before launching the API.

```bash
# Stop existing services
docker compose down

# Pause here to back up the application database

# Edit the docker compose recipe to reference the desired version

# Bring service back online
docker compose up -d
```
