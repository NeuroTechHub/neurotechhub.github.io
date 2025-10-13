# Contributing to NeuroTechHub

Thank you for your interest in contributing to the NeuroTechHub website! We welcome contributions from researchers, engineers, students, and anyone passionate about advancing neurotechnology.

There are several ways to contribute:

- Blog Posts
- Talks & Workshops

## Write a blog post

**Step 1: Propose Your Post**

- Create an issue using our [Blog Post Proposal template](https://github.com/neurotechhub/website/issues/new?template=blog-post-proposal.md) to discuss your idea.

**Step 2: Write Your Post**

Posts use **page bundles** - each post is a folder with an `index.md` and its images:

```
content/blog/posts/my-post/
  ├── index.md
  ├── hero.jpg
  └── diagram.png
```

Create using Hugo CLI:

```bash
hugo new blog/posts/my-post/index.md
```

Use this frontmatter format:

```yaml
---
title: "Your Post Title"
date: "2025-01-XX"
author: "Your Name"
tags: ["tag1", "tag2", "tag3"]
categories: ["tutorial"] # or "research", "hardware", etc.
summary: "Brief description for card view (150-200 characters)"
featured_image: "hero.jpg"  # Image in same folder
draft: true
---

Write your post content in Markdown. Reference images: ![Alt](diagram.png)
```

**Important:**

- Place all images in the same folder as `index.md`, not in `static/`
- **Images must be under 500KB** - optimize before uploading:

  **Option 1: Use our optimization script** (recommended)
  ```bash
  .github/workflows/optimize-images.sh
  ```
  This automatically resizes/compresses all oversized images in your content.

  **Option 2: Use online tools**
  - [TinyPNG](https://tinypng.com/), [Squoosh](https://squoosh.app/), or ImageOptim
  - Resize to reasonable dimensions (max 2000px width)
  - Convert to WebP or AVIF format for better compression

## Propose a talk

- Create an issue using our [Talk Proposal template](https://github.com/neurotechhub/website/issues/new?template=talk-proposal.md)
- Our events team will work with you to schedule and promote your talk

## Local Development

If you want to see what your post will look like, you can deploy the website locally and see.

### Prerequisites

- [Hugo](https://gohugo.io/installation/)
- [Git](https://git-scm.com/)
- Text editor of your choice

### Setup

```bash
# Clone the repository
git clone https://github.com/neurotechhub/website.git
cd website

# Start development server
hugo server --buildDrafts

# Site will be available at http://localhost:1313
```

### Project Structure

```
├── content/
│   ├── blog/posts/my-post/     # Page bundles
│   │   ├── index.md            # Post content
│   │   └── images...           # Images with post
│   └── talks/events/my-talk/   # Same structure
│       ├── index.md
│       └── images...
├── themes/neurotech-theme/     # Hugo theme
└── .github/workflows/          # CI/CD
```

### Content Creation

```bash
# Create blog post with page bundle
hugo new blog/posts/my-post/index.md

# Create talk/event
hugo new talks/events/my-talk/index.md

# Preview with drafts
hugo server --buildDrafts --buildFuture
```

### Test Validation Locally

Before submitting, test that your content passes validation:

```bash
.github/workflows/validate-content.sh
```

This checks:

- Required frontmatter fields
- All images exist in page bundle
- All images are under 500KB
- No unused files in folders

**If validation fails due to image sizes**, run the optimization script:

```bash
.github/workflows/optimize-images.sh
```

Then run validation again to confirm all checks pass.

## Troubleshooting

- **General Questions**: Open a [GitHub Discussion](https://github.com/neurotechhub/website/discussions)
- **Bug Reports**: Create an [Issue](https://github.com/neurotechhub/website/issues)
- **Real-time Chat**: Join our [Discord](https://discord.gg/neurotech)
- **Email**: Contact us at contact [at] neurotechhub [dot] org

## Resources

### Learning Materials

- [Markdown Guide](https://www.markdownguide.org/)
- Browse existing [blog posts](/blog/) for style and structure
- Check out our [talks](/talks/) for presentation ideas
- Review [issues](https://github.com/neurotechhub/website/issues) for contribution opportunities

---

_Together, we're building the future of neurotechnology. Every contribution, no matter how small, helps our community grow and learn._
