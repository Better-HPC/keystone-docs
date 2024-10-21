# Architecture

Keystone is built on a modular architecture designed to support operation at any scale. 
In high-availability environments, the architecture allows individual components to scale dynamically in response to system outages and client demand. 
It also allows application components to be bundled for deployment on smaller, stand-alone systems, making Keystone adaptable to a wide range of operational contexts.

## Deployment Stack

Keystone employs a traditional, three-tiered web architecture comprising a frontend, backend, and persistence layer.
End user access is typically restricted to the front end layer, but the API is designed with security in mind and can be deployed for broader access.

Asynchronous operations are handled in the backend using the Celery Task Manager.
Although Celery provides support for several cache frameworks, Keystone requires Redis as it's caching layer.
This decision is motivated by the maturity, performance, and broad user support of the Redis platform.

Application data is persisted across a Postgres database and a file storage server.
Unofficial support is provided for SQLite databases, but is only intended for use in demonstrations and development.
The choice of file server is arbitrary so long as it is mountable in the runtime environment.

<figure markdown="span">
  ![architecture.svg](assets/img/architecture.svg)
</figure>

## Application Monitoring

The Keystone API exposes metrics for itself and its supporting services using Prometheus.
Metrics for the frontend are scraped directly from Nginx.
In both cases, the collected metrics are designed to focus on application behavior and performance, not on the health of underlying infrastructure.
Deploying additional monitoring for supporting infrastructure is up to the deployment administrator.

<figure markdown="span">
  ![monitoring.svg](assets/img/monitoring.svg)
</figure>
