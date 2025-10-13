+++
title       = "{{ replace .Name "-" " " | title }}"
type        = "blog"
date        = {{ .Date }}   
draft       = true

description = ""            # shorter meta / SEO description
summary     = ""            # what list pages often render
author      = "NeuroTech Hub"
tags        = []
categories  = []

# Optional visual fields that many themes look for:
image       = ""            # path under /static or page bundle
featured    = false
+++

## {{ replace .Name "-" " " | title }}

Write your post here.
