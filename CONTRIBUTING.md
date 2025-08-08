# Contributing to NeuroTechHub

Thank you for your interest in contributing to the NeuroTechHub website! We welcome contributions from researchers, engineers, students, and anyone passionate about advancing neurotechnology.

## Ways to Contribute

### 📝 Blog Posts

Share your knowledge, research, tutorials, and insights with the community.

### 🎤 Talks & Workshops

Propose presentations, workshops, or discussion topics for our community events.

### 🐛 Bug Reports & Improvements

Help us improve the website by reporting issues or suggesting enhancements.

### 🔧 Technical Contributions

Contribute to the website's code, design, or infrastructure.

## Getting Started

### 1. Blog Post Contributions

**Step 1: Propose Your Post**

- Create an issue using our [Blog Post Proposal template](https://github.com/neurotechhub/website/issues/new?template=blog-post-proposal.md)
- Wait for initial approval from maintainers

**Step 2: Write Your Post**

- Fork this repository
- Create a new branch: `git checkout -b blog/your-post-title`
- Create your post file: `content/blog/posts/your-post-title.md`

**Step 3: Follow Our Template**

```yaml
---
title: "Your Post Title"
date: 2025-01-XX
author: "Your Name"
tags: ["tag1", "tag2", "tag3"]
categories: ["tutorial", "research", "hardware", etc.]
summary: "Brief description for card view (150-200 characters)"
featured_image: "/images/posts/your-post.jpg" # optional
draft: false
---
# Your Content Here

Write your post content in Markdown format.
```

**Step 4: Submit for Review**

- Push your changes: `git push origin blog/your-post-title`
- Create a Pull Request with a clear description
- Address any feedback from reviewers

### 2. Talk Proposals

- Create an issue using our [Talk Proposal template](https://github.com/neurotechhub/website/issues/new?template=talk-proposal.md)
- Our events team will work with you to schedule and promote your talk

### 3. Technical Contributions

- Fork the repository
- Create a feature branch: `git checkout -b feature/your-feature`
- Make your changes
- Test locally: `hugo server`
- Submit a Pull Request

## Content Guidelines

### Writing Style

- **Clear and Accessible**: Write for your target audience, define technical terms
- **Actionable**: Include practical examples, code snippets, or step-by-step instructions
- **Well-Structured**: Use headings, lists, and sections to organize content
- **Accurate**: Fact-check technical information and cite sources when appropriate

### Technical Content

- **Code Examples**: Use proper syntax highlighting
- **Reproducibility**: Ensure examples can be run by readers
- **Prerequisites**: Clearly state what knowledge/tools readers need
- **Safety**: Include appropriate warnings for hardware projects

### Images and Media

- **Optimization**: Compress images for web (under 1MB when possible)
- **Alt Text**: Always include descriptive alt text
- **Licensing**: Only use images you have rights to or that are appropriately licensed
- **File Naming**: Use descriptive, kebab-case filenames

## Code Standards

### Hugo/HTML

- Use semantic HTML elements
- Ensure accessibility compliance
- Test on multiple screen sizes
- Follow existing template patterns

### CSS

- Use CSS custom properties (variables)
- Follow mobile-first responsive design
- Maintain consistency with existing styles
- Consider dark mode compatibility

### JavaScript

- Write vanilla JavaScript when possible
- Ensure graceful degradation
- Test across major browsers
- Keep performance in mind

## Review Process

### Blog Posts

1. **Proposal Review**: Maintainers review concept and provide feedback
2. **Draft Review**: Technical accuracy, writing quality, and style
3. **Final Review**: Copy editing and formatting check
4. **Publication**: Merged and deployed automatically

### Technical Changes

1. **Code Review**: Functionality, performance, and standards compliance
2. **Testing**: Automated checks and manual testing
3. **Deployment**: Automatic deployment after merge

## Community Standards

### Code of Conduct

- Be respectful and inclusive
- Focus on constructive feedback
- Welcome newcomers and help them learn
- Avoid controversial topics unrelated to neurotechnology

### Attribution

- Always credit sources and collaborators
- Respect intellectual property
- Use proper citations for research
- Acknowledge community contributions

## Local Development

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

### Common Issues

**Hugo Build Fails**

- Check that all frontmatter is valid YAML
- Ensure all referenced images exist
- Verify Hugo version compatibility

**Images Not Displaying**

- Check file paths (case-sensitive)
- Ensure images are in `static/` directory
- Verify image file formats are supported

**Styling Issues**

- Clear browser cache
- Check CSS syntax
- Ensure responsive design works

### Getting Help

- **General Questions**: Open a [GitHub Discussion](https://github.com/neurotechhub/website/discussions)
- **Bug Reports**: Create an [Issue](https://github.com/neurotechhub/website/issues)
- **Real-time Chat**: Join our [Discord](https://discord.gg/neurotech)
- **Email**: Contact us at contribute@neurotechhub.org

## Recognition

All contributors are recognized in our community:

- Authors are credited on their posts
- Technical contributors are listed in our repository
- Regular contributors may be invited to join our maintainer team
- Outstanding contributions are highlighted in our newsletter

## Resources

### Learning Materials

- [Hugo Documentation](https://gohugo.io/documentation/)
- [Markdown Guide](https://www.markdownguide.org/)
- [Git Handbook](https://guides.github.com/introduction/git-handbook/)

### Inspiration

- Browse existing [blog posts](/blog/) for style and structure
- Check out our [talks](/talks/) for presentation ideas
- Review [issues](https://github.com/neurotechhub/website/issues) for contribution opportunities

---

**Ready to contribute?** Start by browsing our [good first issues](https://github.com/neurotechhub/website/labels/good%20first%20issue) or proposing your own blog post!

_Together, we're building the future of neurotechnology. Every contribution, no matter how small, helps our community grow and learn._
