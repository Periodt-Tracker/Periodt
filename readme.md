<p align="center">
  <img style="width: 10em;" src="./legacy/app/assets/logo.png" alt="blob"/>
  <h1 align="center"> Periodt. </h1>
  <h6 align="center">Your private period(t) tracker.</h6>
</p>

[![Crowdin](https://badges.crowdin.net/periodt/localized.svg)](https://crowdin.com/project/periodt)
[![Linktree](https://img.shields.io/badge/linktree-1de9b6?style=flat&logo=linktree&logoColor=white)](https://linktr.ee/periodt.tracker)

## What and Why?

This app is designed with privacy as a core principle:

No personal or health data is collected

- No analytics, tracking, or third-party services

- All data remains on the user’s device

- You can verify this yourself by reviewing the source code.

## Found a bug?

We'd love to get it fixed for you, you can either open an issue on GitHub [here](https://github.com/Periodt-Tracker/Periodt/issues/new) or reach out to us on [social media](https://linktr.ee/periodt.tracker) or by email.

If you're technical and want to help us out even more feel free to open a pull request fixing your issue.

## This repository

This is Periodt's mono-repo containing everything for the Periodt app and blog

### Develop

The Periodt. app is built with [capacitor](https://capacitorjs.com/) using [solid.js](https://docs.solidjs.com/) as a frontend and [pnpm](https://pnpm.io/) as a package manager.

You can obtain the source code by cloning this repository.

```sh
git clone https://https://github.com/Periodt-Tracker/Periodt
```

And start the development server like so. Note for and android and iOS you must have the respective development SDK's set up: [iOS](https://capacitorjs.com/docs/ios), [Android](https://capacitorjs.com/docs/android)

```sh
pnpm install

cd app

pnpm run dev:web
pnpm run dev:android
pnpm run dev:ios
```

### Build

If you want to build the app from source you can run the following commands for your respective platform

```sh
pnpm run build:android
pnpm run build:ios
```

## License & Data Transparency

This project is source-available and licensed under the MIT License with the Commons Clause.

You are free to view, use, modify, and contribute to the code. However, commercial use is not permitted. The software may not be sold, bundled into paid products, or offered as part of a paid service.

This project exists to support users and the community, not commercial exploitation.
