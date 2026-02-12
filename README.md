# ecromedos

Write in Markdown. Publish to the Web and Print.

ecromedos is a technical document preparation system that produces both
responsive HTML5 and professionally typeset PDF (via LuaLaTeX) from a single
source. Write your documents in Markdown and get high-quality output for both
screen and paper — no compromises on either.

## Why ecromedos?

Most documentation tools force you to choose: either good web output or good
print output. Markdown-based static site generators produce decent HTML but
no print output. LaTeX produces beautiful PDFs but no web output. Pandoc can
target both, but neither output is great without heavy template work.

ecromedos gives you both:

- **HTML5** — Responsive, multi-page, with navigation, syntax highlighting,
  and clean semantic markup.
- **LuaLaTeX/PDF** — Professional typography with KOMA-Script classes,
  microtype, Unicode fonts, and all the refinements you expect from LaTeX.

## Markdown First

Your primary authoring format is Markdown. Use a YAML preamble for metadata:

```markdown
---
title: My Technical Report
author: Jane Doe
date: 2026-01-15
---

# Introduction

This is a regular Markdown document with **bold**, *italic*,
[links](https://example.com), images, tables, code blocks — the works.
```

When you need something Markdown can't express — complex table layouts,
glossaries, indexes, math formulas — drop into ECML (ecromedos Markup
Language) for that section. Markdown handles 90% of the work; ECML is there
for the other 10%.

## Quick Start

```bash
# Convert Markdown to ECML
bin/md2ecml --doctype article guide.md > guide.xml

# Generate HTML
bin/ecromedos -f html guide.xml

# Generate LaTeX (then compile to PDF)
bin/ecromedos -f lualatex guide.xml

# Generate a blank document template
bin/ecromedos -n article > new.xml
```

## Features

- **Three document types** — article, report, and book, with automatic
  chapter/section numbering and table of contents generation.
- **Syntax highlighting** — Code blocks highlighted via Pygments with
  multiple color schemes and optional line numbering.
- **Math formulas** — LaTeX math rendered natively in PDF, converted to
  images for HTML.
- **Tables** — Full table support with column specs, header styling, and
  alternating row colors.
- **Figures** — Automatic image scaling for screen and print, format
  conversion as needed.
- **Cross-references** — Footnotes, bibliography, glossary, and multi-level
  index generation with locale-aware sorting.
- **HTML chunking** — Long documents automatically split into linked pages
  with prev/up/next navigation.
- **Internationalization** — Locale-aware labels and sorting.

## Dependencies

**Required:** Python 3.12+, `lxml`, `pygments`

**For PDF output:** LuaLaTeX

**For math/image processing:** `dvipng`, ImageMagick (`convert`, `identify`)

## Documentation

Full user manual at http://ecromedos.net.

## License

MIT
