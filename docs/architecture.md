# Architecture

Keystone employs a traditional, three-tiered architecture comprising a frontend, backend, and persistence layer.
End user access is typically restricted to the front end layer, but the API can be deployed for access to custom client applications as necessary.
In all cases, incoming user traffic is proxied via Nginx which provides internal routing and load balancing.

<figure markdown="span">
  ![architecture.svg](assets/img/architecture.svg)
  <figcaption>Component level architecture for the combine Keystone application stack.</figcaption>
</figure>

Asynchronous operations are handled in the backend using the Celery Task Manager.
Although Celery provides support for several cache frameworks, Keystone requires Redis as it's caching layer.
This decision is motivated by the maturity, performance, and broad user support of the Redis platform.

Application data is persisted across a Postgres database and a file storage server.
Unofficial support is provided for SQLite databases, but is only intended for use in demonstrations and development.
The choice of file server is arbitrary so long as it is mountable in the runtime environment.

## Application Monitoring

The Keystone API exposes metrics for itself and its supporting services using Prometheus.
Administrators may optionally wish to extend these metrics by deploying dedicated exporters for each underlying service.

<figure markdown="span">
  ![monitoring.svg](assets/img/monitoring.svg)
  <figcaption>Data flow for Keystone metrics aggregation and monitoring.</figcaption>
</figure>

Keystone's metrics provide insight into application behavior and performance.
They do not include information concerning underlying infrastructure (e.g., resource usage on the host machine(s)).
Deploying additional monitoring for supporting infrastructure is left to the system administrator.
