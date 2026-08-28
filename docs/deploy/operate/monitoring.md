# Monitoring &amp; Logging

The Keystone API provides multiple endpoints to support operational monitoring and troubleshooting.
System health checks provide high level status monitoring while application logs and metrics 
offer low level operation details.

## System Health

System health checks offer a high-level overview of the Keystone application stack and its operational status.
These endpoints evaluate system tests on demand and return the current state of the API and its dependencies.

!!! note

    To avoid exposure to DOS style attacks, API health checks are run on the server no more than once every 60 seconds.
    Any additional requests during this time limit will receive a cached result.

| Endpoint        | Description                                                                 |
|-----------------|-----------------------------------------------------------------------------|
| `/health/`      | Returns HTTP 200 if all system checks pass, or HTTP 500 if any check fails. |
| `/health/json/` | Returns detailed health check results in JSON format.                       |
| `/health/prom/` | Returns detailed health check results in Prometheus format.                 |

## Application Logging

Keystone-API exposes application logs through the API endpoints listed below.
All log endpoints require [authentication](../../integrate/api/authentication.md) with administrator privileges and support the
API's standard [query parameters](../../integrate/api/filtering.md).

| Endpoint          | Description                                                        |
|-------------------|--------------------------------------------------------------------|
| `/logs/requests/` | Logs incoming HTTP requests and related metadata.                  |
| `/logs/audit/`    | Audit trail for user actions against select application resources. |
| `/logs/tasks/`    | Results and status of scheduled background tasks.                  |

Clients may optionally specify a unique correlation ID (`cid`) using the `X-KEYSTONE-CID` header.
This value is propagated through internal logs, enabling record correlation across logging endpoints.
Clients should leverage this feature to organize log records around a common transaction or user session.
If a valid CID value is not provided, a unique value is assigned by the server to each incoming request.

CID values must be a valid UUID string, including dashes (e.g. `d61eef0b-258d-42ca-b14b-852860a54259`).

## Performance Metrics

Keystone exposes comprehensive health and performance metrics in Prometheus format.
Each webserver worker exposes metrics on a different port selected across the port range defined in the
[application settings](../configure/api_settings.md).
In accordance with Prometheus conventions, these metrics are accessible via the `/metrics/` endpoint on each port.
No authentication is required to access these endpoints.
