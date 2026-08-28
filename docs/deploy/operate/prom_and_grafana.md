# Prometheus and Grafana

Keystone includes official templates for Prometheus, Grafana, and Alert Manager. The files below are available for
download and can be used as a starting point for configuring monitoring and observability for your Keystone deployment.

## Prometheus Configuration

The Prometheus configuration files define how Prometheus collects metrics from Keystone and how alerting rules are
evaluated. Download the templates below and customize them for your deployment as needed.

| File                                                                                                         | Description                                                                                       |
|--------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------|
| <a href="../../assets/submodules/keystone-demo/demo/prometheus/prometheus.yml" download>prometheus.yml</a>   | Prometheus scrape configuration for collecting metrics from Keystone and its associated services. |
| <a href="../../assets/submodules/keystone-demo/demo/prometheus/alert.rules.yml" download>alert.rules.yml</a> | Prometheus alerting rules for monitoring Keystone metrics and identifying potential issues.       |

## Grafana Dashboards

Keystone provides pre-built Grafana dashboards for monitoring API activity, Celery workers, database metrics, and
application logs. Download the dashboard JSON files and import them into your Grafana instance.

| Dashboard                                                                                                                      | Description                                                   |
|--------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------|
| <a href="../../assets/submodules/keystone-demo/demo/grafana/dashboards/keystone_api.json" download>keystone_api.json</a>       | Dashboard for Keystone API status, performance, and activity. |
| <a href="../../assets/submodules/keystone-demo/demo/grafana/dashboards/keystone_celery.json" download>keystone_celery.json</a> | Dashboard for Celery worker status and task processing.       |
| <a href="../../assets/submodules/keystone-demo/demo/grafana/dashboards/keystone_db.json" download>keystone_db.json</a>         | Dashboard for PostgreSQL database metrics and performance.    |
| <a href="../../assets/submodules/keystone-demo/demo/grafana/dashboards/keystone_logs.json" download>keystone_logs.json</a>     | Dashboard for and exploring Keystone application logs.        |
