# Architecture

Keystone employs a modular monolithic architecture, grouping common services into distinct modules based on a common responsibility. 
This structure allows services within a module to share application resource while maintaining clear boundaries for scalability and maintenance.
Modules or services can be independently scaled to meet user demand, ensuring optimal performance under varying workloads.

## Deployment Stack

Keystone employs a traditional, three-tiered web architecture comprising a frontend, backend, and persistence layer.
End user access is typically restricted to the front end layer, but the API can be deployed for broader access if necessary.
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
Custom Metrics are not provided for the frontend, but can be retrieved directly from Nginx.

<figure markdown="span">
  ![monitoring.svg](assets/img/monitoring.svg)
  <figcaption>Data flow for Keystone metrics aggregation and monitoring.</figcaption>
</figure>

Keystone's metrics provide insight into application behavior and performance.
They do not include information concerning underlying infrastructure (e.g., resource usage on the host machine(s)).
Deploying additional monitoring for supporting infrastructure is left to the system administrator.
