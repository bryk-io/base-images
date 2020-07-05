#!/usr/bin/env sh

TARGET=$(echo "$DRONE_DEPLOY_TO" | tr '[:upper:]' '[:lower:]')
VERSION=$DRONE_TAG
DEPLOYMENT_CHART="./helm/*"
DEPLOYMENT_NAME=$(echo "$DRONE_REPO_NAME"-"$TARGET" | tr '[:upper:]' '[:lower:]')
DEP_ID=$(tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w 16 | head -n 1)

# Verify target
if [ -z "$TARGET" ]; then
  echo "error: no target environment specified"
  exit
fi

# Verify tag
if [ -z "$VERSION" ]; then
  echo "error: only tagged references can be deployed"
  exit
fi

# Install cluster configuration
if [ -z "$KUBECONFIG" ]; then
  echo "error: kubeconfig is required"
  exit
fi
echo "$KUBECONFIG" | base64 -d > "${DEP_ID}-conf"

# Set release name if available on ENV
if [ -n "$RELEASE_NAME" ]; then
  DEPLOYMENT_NAME="$RELEASE_NAME"-"$TARGET"
fi

# Set chart name if available on ENV
if [ -n "$CHART" ]; then
  DEPLOYMENT_CHART="$CHART"
fi

# Load release values.
# 1. Empty file by default.
# 2. Use values file from the repository if present
# 3. Load from ENV
touch "${DEP_ID}-values.yml"
if [ -f "./.deploy/${TARGET}.yml" ]; then
  cp "./.deploy/${TARGET}.yml" "${DEP_ID}-values.yml"
fi
if [ -n "$CHART_VALUES" ]; then
  echo "$CHART_VALUES" | base64 -d > "${DEP_ID}-values.yml"
fi

# Start deployment
echo "=== Environment: ${TARGET}"
echo "=== Version: ${VERSION##v}"
echo "=== Release: ${DEPLOYMENT_NAME}"
# "./helm/*"
helm upgrade "${DEPLOYMENT_NAME}" ${DEPLOYMENT_CHART} \
--kubeconfig "${DEP_ID}-conf" \
--atomic \
--cleanup-on-fail \
--install \
--reuse-values \
--namespace "${TARGET}" \
--values "${DEP_ID}-values.yml" \
"$@"

# Cleanup
rm "${DEP_ID}-values.yml"
rm "${DEP_ID}-conf"
