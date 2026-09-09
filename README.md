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

## Migration Status

The old `BLOGS` source content has been migrated into `source/`, including 63 posts and their page assets. Generated HTML, CSS, JavaScript, and archive folders are intentionally excluded from version control; they are rebuilt into `public/` by the Pages workflow.

The Pages workflow refuses to deploy if fewer than 20 Markdown posts are present under `source/_posts/`. This keeps an incomplete local migration from replacing the live site.
