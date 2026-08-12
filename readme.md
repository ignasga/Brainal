# Brainal

A personal, rebranded fork of [Bruno](https://github.com/usebruno/bruno) — the open-source API client for exploring and testing APIs.

Based on Bruno, © Anoop M D, Anusree P S and Contributors, released under the [MIT license](license.md). Brainal is not affiliated with or endorsed by the Bruno project or Bruno Software Inc. The Bruno name and logo belong to the upstream project and are not used by this fork's builds.

## Differences from upstream

- Rebranded app identity (name, app id, `brainal://` protocol scheme)
- Telemetry removed
- GitHub Actions workflow for building Windows and macOS desktop apps

## Building

```bash
# Node v22 (see .nvmrc)
npm i --legacy-peer-deps
npm run setup
npm run dev              # run in development mode

npm run build:web        # build the web bundle, then:
npm run build:electron   # package the desktop app (out/ in packages/bruno-electron)
```

Or trigger the **Build Desktop Apps** workflow from the Actions tab and download the installers as artifacts.

## License

[MIT](license.md)
