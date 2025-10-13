---
title: '{{ replace .Name "-" " " | title }}'
type: "talks"
draft: false

# IMPORTANT: theme compares this as a string (YYYY-MM-DD)
event_date: '{{ now.Format "2006-01-02" }}'

talk_type: "talk" # e.g., talk, workshop, seminar
location: ""
summary: ""

# Featured image for the talk (place file in same folder as this index.md)
# Example: : "hero.jpg" → looks for hero.jpg in this folder
featured_image: ""

tags: []
featured: false
---

<!--
Place your images in the same folder as this index.md, e.g.:

content/talks/{{ .Name }}/
  ├─ index.md
  ├─ hero.jpg          ← featured image for cards/lists
  └─ speakers.jpg      ← additional images for content

Reference images in content using: ![Alt text](image.jpg)
-->

# {{ replace .Name "-" " " | title }}

<div style="max-width: 900px; margin: 1rem auto;">
  <img src="hero.jpg" alt="Describe the main scene (accessibility)" style="max-width: 100%; height: auto; border-radius: 0.5rem;">
  <p style="text-align: center; font-style: italic; margin-top: 0.5rem;">Optional caption for the hero image.</p>
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
