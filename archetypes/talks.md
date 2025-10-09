+++
title      = '{{ replace .Name "-" " " | title }}'
type       = 'talks'
draft      = false

# IMPORTANT: theme compares this as a string (YYYY-MM-DD)
event_date = '{{ now.Format "2006-01-02" }}'

talk_type  = 'talk'        # e.g., talk, workshop, seminar
location   = ''
summary    = ''

# Card/preview image for lists (expects this file in the bundle)
image      = 'hero.jpg'

tags       = []
featured   = false
+++

<!--
Place your images next to this index.md, e.g.:

content/talks/{{ .Name }}/
  ├─ index.md
  ├─ hero.jpg          ← used by the figure below and the list card via .Params.image
  └─ speakers.jpg      ← add more images as needed
-->

# {{ replace .Name "-" " " | title }}

<div style="max-width: 900px; margin: 1rem auto;">
  {{< figure src="hero.jpg" alt="Describe the main scene (accessibility)" caption="Optional caption for the hero image." >}}
</div>

## Overview
Write a short abstract or details here.

## When & where
- **Date:** {{ now.Format "2 January 2006" }}
- **Location:** {{ with .Site.Params.default_location }}{{ . }}{{ else }}Add venue here{{ end }}

## Agenda
- Keynote
- Team sprint / workshop
- Pitches

## Registration
Add your registration link here.
