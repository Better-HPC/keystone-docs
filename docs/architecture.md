# Architecture

Keystone is built on a modular architecture designed to fit multiple deployment scenarios. 
In high-availability environments, the architecture allows individual components to scale dynamically in response to system outages and client demand. 
It also allows application components to be bundled for deployment on smaller, stand-alone systems.
This flexibility provides a robust solution adaptable to a wide range of operational contexts.

## Deployment Stack

Keystone employs a traditional, three-tiered web architecture comprising a frontend, backend, and persistence layer.
End user access is typically restricted to the front end layer, but the API is designed with security in mind and can be deployed for broader access.

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
They do not include information concerning underlying infrastructure (e.g., the host machine(s)).
Deploying additional monitoring for supporting infrastructure is up to the deployment administrator.
