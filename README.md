# Drone Deployer
[![Version](https://img.shields.io/github/tag/bryk-io/drone-deployer.svg)](https://github.com/bryk-io/drone-deployer/releases)
[![Software License](https://img.shields.io/badge/license-BSD3-red.svg)](LICENSE)


The deployer image allows to easily automate tasks related to deploying a
complex application to a Kubernetes cluster using Helm. The deployer will
use the __target__ value as the corresponding __namespace__ in the cluster to
install the application.

Required variables (usually managed using secrets in Drone's repository):

- __PLUGIN_DEPLOYER_HELM_RELEASE_NAME:__ Name to use for the helm release.
- __PLUGIN_DEPLOYER_HELM_RELEASE_VALUES:__ Custom values to use when deploying the
  chart (base64 encoded).
- __PLUGIN_DEPLOYER_KUBE_SERVER:__ Endpoint to communicate with the cluster's API server.
- __PLUGIN_DEPLOYER_KUBE_CA_DATA:__ Certificate authority used by the cluster
  (base64 encoded).
- __PLUGIN_DEPLOYER_KUBE_TOKEN:__ Access token for the service account used to perform
  the deployment. Must have sufficient privileges in the target namespace used.

> Use the provided rbac-sample.yaml to generate a valid service account for the deployer.

Pipeline step sample configuration.

```yaml
steps:
- name: deploy
  image: drone-deployer:0.1.0
  commands:
  - run deploy
  environment:
    PLUGIN_DEPLOYER_HELM_RELEASE_NAME:
      from_secret: helm-release-name
    PLUGIN_DEPLOYER_HELM_RELEASE_VALUES:
      from_secret: helm-release-values
    PLUGIN_DEPLOYER_KUBE_CA_DATA:
      from_secret: kube-ca-data
    PLUGIN_DEPLOYER_KUBE_SERVER:
      from_secret: kube-server
    PLUGIN_DEPLOYER_KUBE_TOKEN:
      from_secret: kube-token
  when:
    event:
    - promote
```
