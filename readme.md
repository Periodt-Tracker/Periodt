<p align="center">
  <img style="width: 10em;" src="./app/assets/icon-full.png" alt="blob"/>
  <h1 align="center"> Periodt. </h1>
  <h6 align="center">Your private period(t) tracker.</h6>
</p>

## What and Why?

### Privacy First

This app is designed with privacy as a core principle:

No personal or health data is collected

- No analytics, tracking, or third-party services

- All data remains on the user’s device

- You can verify this yourself by reviewing the source code.

## Develop

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
