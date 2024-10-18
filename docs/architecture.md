# Architecture

Keystone is built on a modular architecture designed to support operation at any scale. 
In high-availability environments, the architecture allows individual components to scale dynamically in response to system outages and client demand. 
This flexibility ensures resilience and uninterrupted service during periods of high traffic or partial system failures. 
It also allows application components to be bundled for deployment on smaller, stand-alone systems, making Keystone adaptable to a wide range of operational contexts.

## Application Stack

Keystone employs a traditional, three-tiered web architecture comprising a frontend, backend, and persistence layer.
End user access is typically restricted to the front end layer, but the API is designed with security in mind and can be deployed for broader access.

<figure markdown="span">
  ![architecture.svg](assets/img/architecture.svg)
  <figcaption>
    Keystone is built on a Python (Django) backend with a Javascript (Angular) front end.
    Asynchronous operations are handled by Celery while communication with HPC clusters is facilitated by Slurm.
    Arrows are used to should the direction of network communication.
  </figcaption>
</figure>



Asynchronous operations are handled in the backend using the Celery Task Manager.
Although Celery provides support for several cache frameworks, Keystone requires Redis as it's caching layer.

Reverse proxies are used to serve static content and to load balance incoming requests to the frontend/backend layers.

## Monitoring

The Keystone API exposes metrics for itself and its supporting services using Prometheus.
These metrics are designed to focus on application behavior and performance, not on the health of underlying infrastructure.
Deploying additional monitoring for supporting infrastructure is up to the deployment administrator.

<figure markdown="span">
  ![monitoring.svg](assets/img/monitoring.svg)
</figure>
