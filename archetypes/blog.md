---
title: "{{ replace .Name "-" " " | title }}"
type: "blog"
date: {{ .Date }}
draft: true

description: ""            # shorter meta / SEO description
summary: ""            # what list pages often render
author: "NeuroTech Hub"
tags: []
categories: []

# Featured image for the post:
# Place image file in the same folder as this index.md
# Example: featured_image: "hero.jpg" → looks for hero.jpg in this folder
featured_image: ""
---

## {{ replace .Name "-" " " | title }}

Write your post here.

<!--
To add images in your post content, place them in this folder and reference:
![Alt text](image.jpg)
-->
