# Drone Helm

Perform deployment operations as part of a Drone pipeline using Helm 3. To make
operations simpler, safer and consistent, most of the behavior of the deployments
are set by convention.

1. A target environment is required. Read from ENV variable `DRONE_DEPLOY_TO`.
2. Only tagged references can be deployed. Read from the ENV variable `DRONE_TAG`.
3. Releases are deployed to a namespace named after the target environment selected.
4. The release name is set to the repository name or to the value on the ENV variable
   `RELEASE_NAME`; followed by the target environment.
5. The chart used for the deployment is read from the repository root on `./helm/*`
   or directly set using the ENV variable `CHART`.
6. Only one chart is supported by each deployment step. To install multiple charts,
   add multiple steps to the pipeline.
7. A valid kubeconfig file is required. It must be set, in __base64 encoding__, using
   the `KUBECONFIG` ENV variable. The recommended way is to use a secret. 
8. Chart values can be provided in the following ways.
    - No values provided means using the chart defaults.
    - A `$DRONE_DEPLOY_TO.yml` file in the root repository `./deploy`. For example, values
      for a `production` environment will be stored on the file `./deploy/production.yml`
    - As a __base64 encoded__ value in the `CHART_VALUES` ENV variable.  

Sample deployment pipeline.

```yaml
kind: pipeline
type: kubernetes
name: CD

steps:
  - name: deploy
    image: drone-helm:0.1.0
    environment:
      RELEASE_NAME: "my-service"
      CHART: "./another/location/my-chart"
      CHART_VALUES:
        from_secret: my-config
      KUBECONFIG:
        from_secret: kubeconfig

trigger:
  event:
    - promote
    - rollback
```

To further customize the deployment you can use the `commands` element on the pipeline
step to pass additional parameters to the `deploy` command. All the parameters available
to for `helm upgrade` are supported.

```yaml
commands:
  - deploy --debug --dry-run
```

To test the pipeline locally, use `drone exec`. [More information](https://docs.drone.io/quickstart/cli/)

```shell script
DRONE_TAG=v0.1.0 \
DRONE_DEPLOY_TO="production" \
DRONE_REPO_NAME="my-service" \
drone exec --pipeline="CD" --secret-file secrets.txt --event promote
```
