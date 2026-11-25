# Generating the documentation

The documentation site at <https://dschach.github.io/record-types/> is built with
[ApexDox VS Code](https://github.com/no-stack-dub-sack/apexdox-vs-code). This folder holds the
source assets it consumes; the generated site lands in [`docs/`](../docs/).

## Prerequisites

1. **Install the ApexDox extension.** It is _not_ listed in
   [`.vscode/extensions.json`](../.vscode/extensions.json), so VS Code will not recommend it. Install it
   directly:

   ```sh
   code --install-extension PeterWeinberg.apexdox-vs-code
   ```

   Verify with `code --list-extensions | grep apexdox`.

2. **Install the dev dependencies.** The setup script uses `marked` and `highlightjs-apex` from
   `node_modules`, so this must be done before generating:

   ```sh
   npm ci
   ```

   Use `npm ci` rather than `npm install` — it installs exactly what `package-lock.json` pins, so
   the generated HTML is reproducible and the lockfile is never modified as a side effect. Use
   `npm install` only when you are intentionally adding or upgrading a dependency.

3. **Open the repository root in VS Code.** ApexDox resolves every path in
   [`apexdox.yml`](../apexdox.yml) against `${workspaceFolder}`, so it fails or documents the wrong
   files if you run it from a parent folder or a multi-root workspace.

> **Platform note:** `setupApexDox.sh` uses BSD `sed -i ""`, which works on macOS as written. On
> Linux, GNU `sed` needs `sed -i` with no empty argument, so the script must be edited to run there.

## Generating

Three steps, in this order:

### 1. Build the static pages

```sh
npm run docs:setup
```

This runs [`setupApexDox.sh`](./setupApexDox.sh), which:

- converts [`README.md`](../README.md) to `doc-assets/main.html` (the site home page)
- converts [`CHANGELOG.md`](../CHANGELOG.md) to `doc-assets/changelog.html`
- rewrites `media/` links to `assets/` and `CHANGELOG.md` links to `changelog.html` in
  `main.html` only, so they resolve on the generated site
- tags the method tables with `class="methodtable"` for styling
- refreshes `highlight.js` via `npm run updateHighlight`

### 2. Run ApexDox

From the VS Code Command Palette (<kbd>Cmd</kbd>+<kbd>Shift</kbd>+<kbd>P</kbd>):

```
ApexDox: Run
```

This reads [`apexdox.yml`](../apexdox.yml) and writes the site into `docs/`. It clears `docs/`
first (`cleanDir: true`), so never hand-edit anything in `docs/`.

> **There is no CLI.** ApexDox VS Code ships as an extension only — no `bin` entry, no npm package —
> so this step cannot be scripted or run in CI. It has to be invoked from the Command Palette inside
> VS Code.

### 3. Format and commit

```sh
npm run prettier:docs
```

`prettier:docs` formats the generated HTML and CSS in `docs/` and `doc-assets/`.

GitHub Pages serves from the `main` branch's `/docs` folder, so **the generated output must be
committed** for the published site to update.

## Other ApexDox commands

| Command                       | What it does                                                             |
| ----------------------------- | ------------------------------------------------------------------------ |
| `ApexDox: Run`                | Generates the site into `docs/`                                          |
| `ApexDox: Open Docs`          | Serves the generated site locally on port 8080 (set in `apexdox.yml`)    |
| `ApexDox: Stub Comment Block` | Inserts a doc-block skeleton above the Apex method or class at the caret |

## What's in this folder

| File                                           | Role                                                                 |
| ---------------------------------------------- | -------------------------------------------------------------------- |
| `setupApexDox.sh`                              | Pre-generation script (`npm run docs:setup`)                         |
| `updateHighlight.sh`                           | Rebuilds `highlight.js` from `node_modules`, falling back to CDN     |
| `main.html`                                    | **Generated** from `README.md` — do not edit by hand                 |
| `changelog.html`                               | **Generated** from `CHANGELOG.md` — do not edit by hand              |
| `index.css`, `styling.css`                     | Site styling; copied to `docs/assets/` by ApexDox                    |
| `highlight.js`, `highlight.css`                | Syntax highlighting bundle (highlight.js + the Apex grammar)         |
| `index.js`                                     | Site behavior; copied to `docs/assets/`                              |
| `logo.png`, `icon.png`, `favicon.png`          | Site imagery                                                         |
| `*.min.css`, `vs2015.css`, `highlight_old.css` | Alternate highlight themes, kept for reference                       |
| `methodstable.html`                            | Unused remnant of an earlier home-page layout (see the commented-out |

                                            `csplit` block in `setupApexDox.sh`)                                       |

## Gotchas

- **Edit `README.md`, not `main.html`.** The home page is generated from the root README on every
  `npm run docs:setup`, so hand edits to `main.html` are overwritten.
- **Relative links in the README must survive the rewrite.** `setupApexDox.sh` only rewrites
  `media/` → `assets/` and `CHANGELOG.md` → `changelog.html`, and only in `main.html`. A link to any
  other repo path (for example `/force-app/main/default/classes/`) will 404 on the published site, so
  use an absolute GitHub URL for those. `changelog.html` gets no rewrites at all, so check its links
  by hand after each run.
- **Any asset referenced by the site must be listed under `assets:` in `apexdox.yml`.** Adding a
  file to this folder is not enough; it will not be copied to `docs/assets/` otherwise.
- **Scope controls what is documented.** `apexdox.yml` currently includes `global`, `public`,
  `private`, and `testMethod`. Adding `protected` or `webService` changes what appears in the
  generated pages.
