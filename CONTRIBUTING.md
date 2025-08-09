# Contributing to NeuroTechHub

Thank you for your interest in contributing to the NeuroTechHub website! We welcome contributions from researchers, engineers, students, and anyone passionate about advancing neurotechnology.

There are several ways to contribute:

- Blog Posts
- Talks & Workshops

## Write a blog post

**Step 1: Propose Your Post**

- Create an issue using our [Blog Post Proposal template](https://github.com/neurotechhub/website/issues/new?template=blog-post-proposal.md)
- Wait for initial approval from maintainers

**Step 2: Write Your Post**

- Navigate to [our GitHub page](https://github.com/NeuroTechHub/Website/tree/main/content/blog/posts) to add a new file to the posts section.
- Click 'Add file' and start writing your post.
- Use the following format, use [Markdown](https://www.markdownguide.org/) for the body:

```yaml
---
title: "Your Post Title"
date: 2025-01-XX
author: "Your Name"
tags: ["tag1", "tag2", "tag3"]
categories: ["tutorial"] # or "research", "hardware", etc.
summary: "Brief description for card view (150-200 characters)"
featured_image: "/images/posts/your-post.jpg" # optional
draft: true
---
# Your Content Here

Write your post content in Markdown format.
```

## Propose a talk

- Create an issue using our [Talk Proposal template](https://github.com/neurotechhub/website/issues/new?template=talk-proposal.md)
- Our events team will work with you to schedule and promote your talk

## Local Development

If you want to see what your post will look like, you can deploy the website locally and see.

### Prerequisites

- [Hugo Extended](https://gohugo.io/installation/) (latest version)
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
├── content/              # All content (blog posts, talks, pages)
│   ├── blog/posts/      # Blog posts
│   ├── talks/events/    # Talk pages
│   └── about/           # Static pages
├── themes/neurotech-theme/  # Custom Hugo theme
│   ├── layouts/         # HTML templates
│   ├── static/          # CSS, JS, images
│   └── assets/          # Build assets
├── static/              # Static files (images, etc.)
└── .github/             # GitHub Actions and templates
```

### Content Creation Commands

```bash
# Create a new blog post
hugo new content/blog/posts/your-post-title.md

# Create a new talk page
hugo new content/talks/events/your-talk-title.md

# Preview with drafts
hugo server --buildDrafts --buildFuture
```

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
