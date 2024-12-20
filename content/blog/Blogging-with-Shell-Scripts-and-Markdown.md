---
title: "Blogging with Shell Scripts and Markdown"
date: 2020-07-23T11:25:49-04:00
draft: true
---
I (used to) manage this website with markdown and a shell scripts. Here's how.

## What I wanted when designing my site:

- Fast load time
- Minimal interface
- A site directory
- Readable URLs

## What I didn't want when designing my site:

- JavaScript
- A fancy framework
- Site analytics/admin interface
- Large files
- Ads

## How it works:

I spent some time in HTML/CSS designing a header for the site. This includes a generic title for each page, an "About" tab, "Posts" tab, "Contact" tab, and horizontal bar to separate the header from the body. I linked each tab to the URL I planned for each page, which is my domain (jarbus.net) followed by the filename with the `.html` extension removed. (e.g. jarbus.net/About)

I write all my posts in markdown, then convert it to HTML using [pandoc](https://pandoc.org/).

I wrote a conversion script to turn an HTML file for a post into an HTML file for the site. I accomplish this by creating a new file consisting of the header HTML mentioned, concatenating with the post HTML afterwards. I also run a `sed` command to replace the generic title in the header for the filename of the post, with dashes replaced with spaces.

I keep my markdown files in a directory called "drafts", which is sibling to the GitHub Pages repository that's hosting my website. When I'm done with a post, I convert it to a site page, move it to the git repository, then push. It's that easy!

The [Posts](/Posts), [About](/About), [Index](jarbus.net), and [Contact](/Contact) pages all maintained as above. I used to have a script to automatically recreate my [Posts](/Posts) page to add new entries, but found that I much prefer the curated & categorical page I have now.


## RSS

I also have an [rss feed](feed), which I update manually. However, given that adding a new entry simply requires putting
```
<item>
  <title>
    PostName
  </title>
  <link>
    https://www.jarbus.net/PostName
  </link>
</item>
```
at the top of my feed file, I think I'll manage. Plus, I enjoy the ability add custom tags on a post by post basis if I decide to.

## Final Thoughts

Overall, I'm really happy with how the site turned out--I have absolute control over all aspects of my blog while doing negligible content management. I have lighting-fast load times, a minimal interface, and can fix any aspect of my site were something to break.
