# Deploy to AppZung CodePush - GitHub Action

[![GitHub Marketplace](https://img.shields.io/badge/Marketplace-Deploy%20to%20AppZung%20CodePush-blue.svg?colorA=24292e&colorB=0366d6&style=flat&longCache=true&logo=github)](https://github.com/marketplace/actions/deploy-to-appzung-codepush)
[![GitHub License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/appzung/github-action-deploy-to-appzung-codepush/master/LICENSE)

A GitHub Action that deploys React Native updates to AppZung CodePush for over-the-air (OTA) updates.

This action installs the AppZung CLI and uses it to deploy your React Native update to AppZung CodePush. This way, your new features or bug fixes will become available to your users much earlier than if you were going through the app store reviews, and development iterations are much faster.

Sign up first at [https://appzung.com](https://appzung.com)

## Features

- 🚀 Fast over-the-air updates for React Native apps
- 🔒 Secure deployment with API key authentication
- 📦 Support for code signing with private keys
- 🎯 Targeted rollouts with percentage-based distribution
- 🔄 Mandatory and optional update controls
- 📝 Automatic release descriptions from git commits
- 🎨 Flexible configuration with extra flags support

## Usage

```yaml
name: Deploy to AppZung CodePush

on:
  workflow_dispatch:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '22'

      - name: Install dependencies
        run: npm install # or yarn / bun...

      - name: Deploy iOS to AppZung CodePush
        uses: AppZung/github-action-deploy-to-appzung-codepush@v1.0.0
        with:
          api-key: ${{ secrets.APPZUNG_API_KEY }}
          release-channel: 'staging/c95d7950-228c-4f47-8abb-4e275050ca8e'
      
      - name: Deploy Android to AppZung CodePush
        uses: AppZung/github-action-deploy-to-appzung-codepush@v1.0.0
        with:
          api-key: ${{ secrets.APPZUNG_API_KEY }}
          release-channel: 'staging/4ffe006a-567e-491b-b3e4-2830087ff980'
```

## Inputs

| Input | Description                                                                                                       | Required | Default |
|-------|-------------------------------------------------------------------------------------------------------------------|----------|---------|
| `api-key` | AppZung API key for authentication                                                                                | Yes | - |
| `release-channel` | The release channel ID to deploy to (e.g., `myChannel/c95d7950-228c-4f47-8abb-4e275050ca8e`)                      | Yes | - |
| `mandatory` | Specifies whether this release should be considered mandatory                                                     | No | `false` |
| `disabled` | Specifies whether this release should be disabled (not immediately available)                                     | No | `false` |
| `rollout` | Percentage of users this release should be available to (e.g., `95` for 95%)                                      | No | `''` |
| `target-binary-version` | Semver version specifying the binary app version this release is compatible with | No | `''` |
| `private-key` | Private key for code signing. Can be either a file path or the actual private key content                         | No | `''` |
| `description-from-git` | Use the current git commit message as the release description                                                     | No | `false` |
| `extra-flags` | Additional command line flags (e.g., `--disable-duplicate-release-error --use-hermes`)                            | No | `''` |
| `working-directory` | Directory to run the deploy command from (useful for monorepos)                                                   | No | `.` |

## Setting up secrets

1. Go to your repository settings
2. Navigate to **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add your AppZung API key:
   - Name: `APPZUNG_API_KEY`
   - Value: Your API key from AppZung dashboard

## Getting your release channel ID

1. Login in the AppZung CLI
2. Run `appzung release-channels list`

## Code signing

To use code signing with your releases:

1. Generate a private/public key pair
2. Store the private key content as a GitHub secret (e.g., `APPZUNG_PRIVATE_KEY`)
3. Use the public key in your React Native app (see [doc](https://github.com/AppZung/react-native-code-push/blob/main/docs/code-signing.md))
4. Pass the private key content:

```yaml
with:
  private-key: ${{ secrets.APPZUNG_PRIVATE_KEY }}
```

## Troubleshooting

### Authentication errors
- Verify your API key is correct and has proper permissions
- Check that the secret is properly configured in GitHub

### Release channel not found
- Ensure the release channel ID includes at least a UUID
- Verify the format: `channelName/uuid` (channelName helps with readability)

### Build failures
- Make sure Node.js is set up before running this action
- Ensure all dependencies are installed
- Check that your working directory is correct for monorepos

## Requirements

- Node.js (recommended: v18 or later)
- A React Native project
- An AppZung account and API key

## Related actions

- [actions/checkout](https://github.com/actions/checkout) - Check out your repository
- [actions/setup-node](https://github.com/actions/setup-node) - Set up Node.js environment

## Contributing

We welcome issues and pull requests! Please visit our [GitHub repository](https://github.com/appzung/github-action-deploy-to-appzung-codepush) to contribute.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Learn more

- [AppZung](https://appzung.com)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
