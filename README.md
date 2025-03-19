# Artillery Load Testing Helm Chart

This Helm chart deploys Kubernetes CronJobs for on-demand load testing using Artillery.io. Each CronJob corresponds to a specific API endpoint under test, allowing easy configuration through `values.yaml`.

## Features

- **One CronJob per endpoint**: Define multiple endpoints, and the chart will generate a CronJob for each.
- **Configurable test parameters**: Set stress test details such as requests per second, duration, and virtual users.
- **Manual triggering**: CronJobs are configured not to run automatically but to be manually triggered when needed.
- **Long-running containers**: Test containers remain alive for a configurable duration after execution to allow log retrieval.
- **Lightweight & Simple**: Minimal dependencies, using vanilla Kubernetes resources and Helm for easy customization.

## Installation

```bash
helm install load-testing ./artillery-load-testing
```

## Configuration

The following table lists the configurable parameters of the Artillery Load Testing chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `image.repository` | Artillery image repository | `artilleryio/artillery` |
| `image.tag` | Artillery image tag | `latest` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `endpoints` | List of API endpoints to test | See `values.yaml` |
| `keepAliveDuration` | Time (in seconds) the container stays alive after test completion | `300` |

### Endpoint Configuration

Each endpoint in the `endpoints` list can have the following properties:

```yaml
endpoints:
  - name: "test-api-1"      # Name of the endpoint (used for CronJob naming)
    url: "https://api.example.com/test1"  # Target URL
    method: "GET"           # HTTP method
    duration: 60            # Test duration in seconds
    requestsPerSecond: 10   # Number of requests per second
    virtualUsers: 5         # Number of virtual users

  - name: "test-api-2"
    url: "https://api.example.com/test2"
    method: "POST"
    body: '{"key": "value"}'  # Request body for POST requests
    duration: 120
    requestsPerSecond: 20
    virtualUsers: 10
```

## Usage

### Manually Triggering a Load Test

To manually trigger a load test for a specific endpoint:

```bash
kubectl create job --from=cronjob/release-name-artillery-load-testing-test-api-1 test-api-1-manual-001
```

Replace `release-name` with your Helm release name and `test-api-1` with the name of your endpoint.

### Viewing Test Results

To view the logs from a load test:

```bash
kubectl logs job/test-api-1-manual-001
```

The container will remain alive for the duration specified in `keepAliveDuration` after the test completes, allowing you to retrieve the logs.

## Customization

You can customize the Artillery test configuration by modifying the `configmap.yaml` template or by adding additional configuration options to the `values.yaml` file.