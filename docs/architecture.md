The Keystone platform is designed around a centralized REST API that interfaces with HPC clusters using a lightweight
agent application.
The central API handles core application logic and user permissions, while the
cluster agents provide a hardware-agnostic interface between Keystone and the local HPC scheduler. This
architecture enables a single Keystone deployment to efficiently manage multiple clusters across many heterogeneous
environments.

The following sections detail the Keystone architecture and its underlying services.
Application components are organized into distinct layers, each defined by a specific responsibility.

<figure markdown="span">
  ![architecture.svg](assets/media/architecture.svg)
  <figcaption>
    Component level architecture for the Keystone platform.
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
This layer serves as the application control plane and is responsible for coordinating user requests and processing
asynchronous background tasks.

- **Keystone API**  
  A REST API responsible for the centralized management of distributed HPC resources.

- **Task Scheduler**  
  A periodic task scheduler responsible for coordinating asynchronous background jobs.

- **Background Workers**  
  Worker processes responsible for executing long-running background tasks.

## Data Persistence

Keystone persists application data across multiple specialized storage systems.

- **Primary Database**  
  Stores transactional and relational application data.

- **Redis Cache**  
  Provides in-memory caching and message brokering to support asynchronous task execution.

- **File Storage**  
  Manages binary and unstructured data such as file attachments and user uploads.

## HPC Resources

HPC resources are owned and operated by the customer and remain outside of Keystone’s direct administrative domain.
Integration is achieved using an agent application installed on each cluster. This agent provides a compatibility
layer between Keystone and the underlying HPC scheduler, abstracting scheduler-specific details and enabling Keystone
to enforce allocation and policy constraints.
