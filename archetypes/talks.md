---
title: '{{ replace .Name "-" " " | title }}'
speaker: ""
# IMPORTANT: theme compares this as a string (YYYY-MM-DD)
event_date: '{{ now.Format "2006-01-02" }}'
# Event time in 24-hour format (HH:MM)
event_time: '{{ now.Format "15:04" }}' # Optional
event_timezone: "UTC" # Optional
draft: false
# Featured image for the talk (place file in same folder as this index.md)
# Example: : "img.jpg" → looks for img.jpg in this folder
featured_image: "" # Optional

talk_type: "talk" # e.g., talk, workshop, seminar
location: ""
summary: ""

tags: []
registration_link: "" # Optional
recording_link: "" # Optional
---

<!--
Place your images in the same folder as this index.md, e.g.:

content/talks/{{ .Name }}/
  ├─ index.md
  ├─ img.jpg          ← featured image for cards/lists
  └─ speakers.jpg      ← additional images for content

Reference images in content using: ![Alt text](image.jpg)
-->

## Overview

Write a short abstract or details here.

## Agenda

- Keynote
- Team sprint / workshop
- Pitches

<div style="max-width: 900px; margin: 1rem auto;">
  <img src="img.jpg" alt="Describe the main scene (accessibility)" style="max-width: 100%; height: auto; border-radius: 0.5rem;">
  <p style="text-align: center; font-style: italic; margin-top: 0.5rem;">Optional caption for the img image.</p>
</div>
