# Introduction 
Little bash dockerized application that run [lighthouse](https://developers.google.com/web/tools/lighthouse) tests, get the metrics and upload to InfluxDB

# Getting Started
You need the next software:
- Development:
    - Docker
    - make
    - InfluxDB
- Production:
  - Docker
  - make
  - InfluxDB
  - Kubernetes Cronjobs

# Build and Test
Run `make build` and after this run it with `make run`.
If you need to debug the execution you can use `make shell`

The hosts that you want to analize can be defined in the environment variables, we defined four categories, `HOSTS_HOME` home pages, `HOSTS_PRODUCT` metric for products pages, `HOSTS_SEARCH` metrics for search pages and `HOSTS_BRAND` metrics for brands pages

You can use the `crontabs/crontab_metric_lighthouse_performance.yaml` to create the kubernetes cronjob and forget about the execution :D

# License

You can check the license [here](./LICENSE)
