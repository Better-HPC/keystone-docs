# Architecture

Keystone’s core architecture is organized into three layers: user presentation, application logic, and data storage.
The presentation layer provides general user-facing interfaces, including a web UI and Python SDK.
The application layer enforces business logic and coordinates HPC resource allocations across clusters. 
The storage layer provides persistence for application data and user-submitted content.

Integration with HPC hardware is handled by a lightweight agent application, which provides a scheduler-agnostic
interface for managing the underlying cluster(s). This enables Keystone to efficiently manage HPC resources across
diverse computational environments.

The diagram and sections below provide a detailed overview of the components in a typical Keystone deployment.
Traditional enterprise services (e.g., LDAP, SSO, SMTP) are omitted here for simplicity.

<figure markdown="span">
  ![architecture.svg](assets/media/architecture.svg)
  <figcaption>
    A component level architecture for the Keystone platform.
    External enterprise services (e.g., LDAP, SMTP) are omitted for simplicity.
  </figcaption>
</figure>

## Presentation Layer

The Keystone Web UI is designed to support general user workflows and day-to-day tasks.
Administrators are welcome to build and deploy additional interfaces using the official Python client and REST API.

- **Web Front End**  
  A browser-based user interface providing interactive access suitable for both end users and administrators.

- **Custom Applications**  
  Keystone provides an official Python SDK to support developers interested in automating daily workflows and building
  custom client applications.

## Application Layer

The application layer encapsulates Keystone’s core business logic.
This layer serves as the primary control plane and is responsible for coordinating user requests and processing
asynchronous background tasks.

- **Keystone API**  
  A REST API responsible for the centralized management of distributed HPC resources.

- **Celery Task Scheduler**  
  A periodic job scheduler responsible for coordinating asynchronous application tasks.

- **Celery Workers**  
  Worker processes responsible for executing long-running background tasks.

## Data Persistence

Keystone persists application data across multiple specialized storage systems.

- **Primary Database**  
  Stores transactional and relational application data.

- **Redis Cache**  
  Provides caching and message brokering to support asynchronous task execution.

- **File Storage**  
  Manages binary and unstructured data such as file attachments and user uploads.

## HPC Resources

Integration with HPC resources is achieved using an agent application installed on each cluster.
The agent provides a compatibility layer between Keystone and the underlying HPC scheduler.
It abstracts scheduler-specific details and enables Keystone to enforce allocation and policy constraints.
