# Application Architecture

Keystone’s core architecture is organized into three layers: user presentation,
application logic, and data storage. The presentation layer provides general
user-facing interfaces. The application layer enforces business logic and
coordinates HPC resource allocations across clusters. The storage layer provides
persistence for application data and user-submitted content.

Integration with HPC hardware is handled by a lightweight daemon application,
which provides a scheduler-agnostic interface for managing the underlying
cluster(s). This enables Keystone to efficiently manage HPC resources across
diverse computational environments.

The diagram and sections below provide a detailed overview of the components in a
typical Keystone deployment. Traditional enterprise services (e.g., LDAP, SSO,
SMTP) are omitted here for simplicity.

![A component level architecture for the Keystone platform.](../../assets/images/architecture.svg)
/// caption
A component level architecture for the Keystone platform. External enterprise
services (e.g., LDAP, SMTP) are omitted for simplicity.
///
