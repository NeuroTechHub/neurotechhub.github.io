# Contributing to NeuroTechHub

Thank you for your interest in contributing to the NeuroTechHub website! We welcome contributions from researchers, engineers, students, and anyone passionate about advancing neurotechnology.

There are several ways to contribute:

- Writing or contributing to blogposts
- Organising or suggesting workshops, talks and other events

> [!NOTE]
> Before you start writing a post, discuss with us to optimise for the most efficient post writing. We're happy to help you in the process. You can do this by creating an [Issue](https://github.com/neurotechhub/website/issues/new?template=blog-post-proposal.md).

## Write a blog post

There are two ways to go about this, either you do it in the github UI (you'll need a github account) or you do it on your computer (for more experienced developers that know how to use git).

### Via GitHub

GitHub hosts our entire website. If we change files there, they change on the website. This approach lets you add a text file with some optional images in a certain structure.

> [!IMPORTANT]
> If you don't have experience with git and GitHub, the best way to approach this is to first write and finish your entire post. When that's done, continue to upload it in one go.

**Step 1: Create a GitHub account**

You can do that [here](https://github.com/signup).

**Step 2: Prepare your post**

The blog post body should be written in Markdown, this is a rich text editor, think of it as a just .txt but with more options like headings, bold text, lists, tables, images, etc. You can read more about it [here](https://www.markdownguide.org/), you can write your post [here](https://markdownlivepreview.com/) to see what it will look like.

Furthermore, posts need a 'frontmatter' before the actual post. This information is used by Hugo (our website generator) to manage the post. Here's a frontmatter template that you have to add on top of your post:

```
---
title: "Post title"
date: "2025-12-30" # Use this format: YYYY-MM-DD
draft: false       # This tells Hugo to show it on the website (false) or not (true)
featured_image: "" # Featured image for the talk (place file in same folder as this index.md)
                   # Example: : "img.jpg" → looks for img.jpg in this folder


summary: ""
author: ""
tags: []           # The topic; BCI, open source, news, opinion. Example: tags: ["BCI", "open source"]
---

Your blog post body goes here
```

> [!IMPORTANT]
> The frontmatter will be checked to be correct so you need to follow the template EXACTLY, some things have double quotation marks, some don't, tags are surrounded by square brackets and the items inside have quatation marks.

> [!IMPORTANT]
> Images can't be larger than 500 kB, you need to make the smaller than that, otherwise your post wont be able to be uploaded to the website.

**Step 2: Create the correct folder and file**

Posts use **page bundles** - each post is a folder with an `index.md` and its images:

```
content/blog/posts/my-post/
  ├── index.md
  ├── image.jpg
  └── diagram.png
```

1. Navigate to [github.com/NeuroTechHub/neurotechhub.github.io/](github.com/NeuroTechHub/neurotechhub.github.io/). Find the button that says **Fork** and click it. In the next screen, click **Create fork**. You now have a copy of our website on your GitHub account.
2. Navigate to the `content/blog/posts` folder or go here [github.com/YOURUSERNAME/neurotechhub.github.io/tree/main/content/blog/posts/](github.com/YOURUSERNAME/neurotechhub.github.io/tree/main/content/blog/posts/) (replace YOURUSERNAME with your GitHub user name). You have to create a new folder for your post there.
3. Click on the **Add file** button in the top right, and then click **Create new file**.
4. Somewhere near the top it says `Name your file...`. Here you first need to write the name of the folder your post exists in. Write something like `this_is_my_post_title/`. The `/` at the end is important, it will create a folder. In the field that appears next, write `index.md`.
5. Paste your post in the text field below. If you have images that you want to add (we'll add the files later), you have to reference them EXACTLY, even when the reference has capitals and the filename doesn't, it won't work.
6. Click **Commit changes...** in the top right. A popup appears, you can optionally add text but leave the "Commit directly to the `main` branch" selected, click **Propose changes**. What this does is that it adds your blog text to your version of the website.
7. To add images, press the **Add file** button again, this time click **Upload files**. Add the files to the next screen (drag and drop or click "choose your files"). And similar to the previous step, click **Commit changes**.
8. Click **Contribute** on [github.com/YOURUSERNAME/neurotechhub.github.io/tree/main/content/blog/posts/](github.com/YOURUSERNAME/neurotechhub.github.io/tree/main/content/blog/posts/). Then click **Open pull request**. This creates a request to add your post to the main website which we will review.
9. You need to write a title for your pull request. Please also add a nice description for us to understand why you want this post on the website and why you think it is relevant. Click **Create pull request**.

We will review it and post it when it's ready!

### Developing locally

1. install [Hugo](https://gohugo.io/installation/)
2. fork and clone the repo
3. cd into the repo and create a new folder: `/content/blog/posts/[your_post_name]`
4. create an `index.md` and add images to this folder as well
5. copy the content of `archetypes/blog.md` to `index.md` to have the correct frontmatter
6. edit frontmatter and text
7. preview website with: `hugo server --buildDrafts`
8. when you're happy; create a PR

**Important:**

- **Images must be under 500KB**
  You can use this script that has to have image magick installed:
  ```bash
  .github/workflows/optimize-images.sh
  ```
  This automatically resizes/compresses all oversized images in your content.
- **Validate content**
  You can check if your post is correctly designed:
  ```bash
  .github/workflows/validate-content.sh
  ```

## Propose a talk

- Create an issue using our [Talk Proposal template](https://github.com/neurotechhub/website/issues/new?template=talk-proposal.md)
- We will work with you to develop, schedule and promote your talk

## Troubleshooting

- **General Questions**: Open a [GitHub Discussion](https://github.com/neurotechhub/website/discussions)
- **Bug Reports**: Create an [Issue](https://github.com/neurotechhub/website/issues)
- **Real-time Chat**: Join our [Discord](https://discord.gg/FhZA5rB7Tq)
- **Email**: Contact us at contact [at] neurotechhub [dot] org

---

_Together, we're building the future of neurotechnology. Every contribution, no matter how small, helps our community grow and learn._
