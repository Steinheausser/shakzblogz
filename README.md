# shakzblogz

A minimalist, sepia-toned blog and poetry site built with [Astro](https://astro.build).

Live at **https://steinheausser.github.io/shakzblogz/** — every push to `main` redeploys via GitHub Actions.

## Writing

- **Blog posts:** add a `.md` file to `src/content/blog/`
- **Poems:** add a `.md` file to `src/content/poetry/` (line breaks are preserved; blank line between stanzas)

Each file starts with front matter:

```md
---
title: My Title
date: 2026-10-19
description: Optional one-liner
draft: false   # set true to hide it
---
```

The file name becomes the URL, e.g. `first-light.md` → `/poetry/first-light/`.

## Commands

| Command           | Action                                  |
| :---------------- | :-------------------------------------- |
| `npm install`     | Install dependencies                    |
| `npm run dev`     | Local preview at `localhost:4321/shakzblogz/` |
| `npm run build`   | Build the site to `./dist/`             |

Colours live at the top of the `<style>` block in `src/layouts/Base.astro`.
