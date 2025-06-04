# Architecture

Keystone leverages a modular, service-oriented architecture tailored to meet the operational demands of HPC environments.
The diagram below demonstrates the flow of requests between individual components, grouped according to their general responsibilities.
The following sections detail each layer of the Keystone architecture, emphasizing key design decisions and the specific roles of each module.

<figure markdown="span">
  ![architecture.svg](assets/img/architecture.svg)
  <figcaption>
    Component level architecture for the Keystone application.
    Arrows are used to demonstrate the direction of initiated requests between components.
    External enterprise components such as LDAP and SMTP servers are omitted from the diagram.
  </figcaption>
</figure>

## Web Frontend

The application frontend is a TypeScript application built with **Angular** and served behind an **NGINX** proxy.

## API Backend

The Keystone API is a Python application built using the **Django REST Framework (DRF)**.
It encapsulates core business logic, enforces data validation, manages user authentication/permissions.
The API is designed to , and provides
an array of administrative utilities.

Asynchronous operations are handled using the **Celery** task manager, backed by a **Redis** cache.
Although Celery supports multiple message brokers, Keystone requires Redis due to its maturity, performance, and
widespread adoption in production environments.

## Persistence

Keystone uses dedicated storage backends to persist different types of application data, including:

- A **PostgreSQL** relational database for structured data (e.g., users, teams, allocations)
- File storage for static assets and user-uploaded data

The Redis cache is not considered part of the persistence layer, as it is used exclusively by Celery for inter-process
communication and is not accessed directly by application logic.