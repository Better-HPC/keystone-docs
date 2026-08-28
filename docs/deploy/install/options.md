# Deployment Options

Keystone supports several deployment methods, each suited to a different
operational scale. A standalone Docker deployment provides the lowest-overhead
option for small teams and local testing. Using an orchestration tool like
Helm or Docker Compose provides better scalability and is generally
recommended in production settings.

The table below summarizes each deployment method and the environment it best supports.

| Method                       | Best for                      | Notes                                                                            |
|------------------------------|-------------------------------|----------------------------------------------------------------------------------|
| [Docker](docker.md)          | Small deployments             | A minimal deployment suited to small-scale operations or evaluating the product. |
| [Docker Compose](compose.md) | Production without Kubernetes | Recommended for production-grade deployments at small to medium scale.           |
| Helm (Coming Soon)           | Production with Kubernetes    | Recommended for production-grade deployments at medium to large scale.           |
| [Systemd](systemd.md)        | Legacy systems                | A deprecated option for hosts that cannot run containers.                        |
