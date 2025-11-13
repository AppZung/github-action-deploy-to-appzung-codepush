#!/bin/bash
set -e

# GitHub Actions provides inputs through environment variables with INPUT_ prefix
API_KEY="${INPUT_API_KEY}"
RELEASE_CHANNEL="${INPUT_RELEASE_CHANNEL}"
MANDATORY="${INPUT_MANDATORY}"
DISABLED="${INPUT_DISABLED}"
ROLLOUT="${INPUT_ROLLOUT}"
TARGET_BINARY_VERSION="${INPUT_TARGET_BINARY_VERSION}"
PRIVATE_KEY="${INPUT_PRIVATE_KEY}"
DESCRIPTION_FROM_GIT="${INPUT_DESCRIPTION_FROM_GIT}"
EXTRA_FLAGS="${INPUT_EXTRA_FLAGS}"

# Validate required parameters
if [ -z "$RELEASE_CHANNEL" ]; then
    echo "Error: release-channel input is required"
    exit 1
fi

if [ -z "$API_KEY" ]; then
    echo "Error: api-key input is required"
    exit 1
fi

echo "Deploying React Native update to AppZung CodePush..."

# Build the base command using npx to avoid global installation
DEPLOY_CMD="npx --yes @appzung/cli@1 releases deploy-react-native --release-channel \"$RELEASE_CHANNEL\" --api-key \"$API_KEY\""

# Add optional flags
if [ "$MANDATORY" == "true" ]; then
    DEPLOY_CMD="$DEPLOY_CMD --mandatory"
fi

if [ "$DISABLED" == "true" ]; then
    DEPLOY_CMD="$DEPLOY_CMD --disabled"
fi

if [ -n "$ROLLOUT" ]; then
    DEPLOY_CMD="$DEPLOY_CMD --rollout $ROLLOUT"
fi

if [ -n "$TARGET_BINARY_VERSION" ]; then
    DEPLOY_CMD="$DEPLOY_CMD --target-binary-version \"$TARGET_BINARY_VERSION\""
fi

if [ -n "$PRIVATE_KEY" ]; then
    DEPLOY_CMD="$DEPLOY_CMD --private-key \"$PRIVATE_KEY\""
fi

if [ "$DESCRIPTION_FROM_GIT" == "true" ]; then
    DEPLOY_CMD="$DEPLOY_CMD --description-from-current-git-commit"
fi

if [ -n "$EXTRA_FLAGS" ]; then
    DEPLOY_CMD="$DEPLOY_CMD $EXTRA_FLAGS"
fi

echo "Executing deployment command..."
echo "$DEPLOY_CMD"

# Execute the command
eval "$DEPLOY_CMD"

echo "✓ Successfully deployed to AppZung CodePush!"
