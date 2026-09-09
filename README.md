# WuFaye Blog

This repository is being organized as a single-repository Hexo blog:

- Hexo source lives in this repository.
- Posts live in `source/_posts/`.
- GitHub Actions builds Hexo and publishes `public/` to GitHub Pages.

## Write A Post

```powershell
cd C:\Users\19542\Desktop\wf\WuFaye.github.io
npm ci
.\tools\blog-bootstrap.ps1
npm run clean
npm run build
npm run preview
```

New posts should be created under:

```text
source/_posts/
```

Helper scripts live under `tools/` because Hexo reserves the root `scripts/` directory for JavaScript extensions.

## Deploy

Push to `main`; `.github/workflows/pages.yml` builds and deploys the site after the Hexo source migration is complete.

`npm run deploy` is intentionally mapped to a local clean build. In this one-repository setup, publishing is done by GitHub Actions, not by `hexo deploy`.

GitHub repository settings must use:

```text
Settings -> Pages -> Build and deployment -> Source: GitHub Actions
```

## Current Migration Note

The previous generated static site is still tracked in this repository so the live blog is not broken during migration.
After all old Hexo source posts and assets are confirmed migrated, the old generated files can be removed from `main`.

The Pages workflow currently refuses to deploy if fewer than 20 Markdown posts are present under `source/_posts/`. This prevents accidentally replacing the current live blog with a partially migrated Hexo build.
