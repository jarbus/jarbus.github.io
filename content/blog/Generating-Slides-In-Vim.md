---
title: "Generating Slides in Vim"
date: 2021-01-31T11:25:49-04:00
tags: ["technology"]
---
There is a great tool known as [pandoc](https://pandoc.org/) that can convert documents from one filetype to another. For example, you can convert a Microsoft Word document to a PDF, without even needing to own a copy of Microsoft Word! However, we care about Pandoc's ability to convert a Markdown document to a slideshow presentation using LaTeX Beamer as a rendering engine.

There is a great writeup about this basic feature [here](https://ashwinschronicles.github.io/beamer-slides-using-markdown-and-pandoc).

> TL;DR: With Pandoc installed and markdown file `Demo.md`, executing `pandoc -t beamer Demo.md -o Demo.pdf` will generate a slideshow as a pdf, with each section heading as the title of a new slide.

Different themes can be specified with the `-V` option; I'm currently using the [Metropolis](https://github.com/matze/mtheme) beamer theme and [Owl](https://github.com/rchurchley/beamercolortheme-owl) colorscheme. After installing these themes, I can run:

```
pandoc -t beamer
       -V fontsize=14pt
       -V theme=metropolis
       -V colortheme=owl
       -s
       Demo.md -o Demo.pdf
```

to produce my presentation. **Note: All code blocks are single-line commands/`.vimrc` entries, and are displayed as multi-line for readability.**

Unfortunately, it's a pain to recompile a document every time I want to view my changes. Luckily, as a (Neo)Vim user, I can automatically run commands everytime I write a file. To avoid generating presentations with non-presentation markdown files, I instead write presentations in plaintext files that end with `.slides`. In the example above, I'd be using `Demo.slides` instead of `Demo.md`. When I add:

```
autocmd! BufWritePost *.slides silent !pandoc
    -t beamer
    -V fontsize=14pt
    -V theme=metropolis
    -V colortheme=owl
    -s
    % -o "%:p:h/.%:t:r.pdf"
```

to my `.vimrc`, everytime I save changes in a `FILENAME.slides` file, it will generate a presentation located in `.FILENAME.pdf`. I choose to add a leading period in the output to hide the PDF from my file manager, feel free to remove it.


To enable markdown syntax highlighting in our `.slides` file, add:

```
autocmd BufRead,BufNewFile *.slides :set filetype=markdown
```

to your `.vimrc`.

Now Vim generates a PDF presentation for us everytime we save a `.slides` file. For easy viewing, I added another keybind, `Z`, to open the corresponding PDF in my PDF viewer of choice, [Zathura](https://pwmt.org/projects/zathura/):

```
nnoremap Z :silent !zathura --fork %:p:h/.%:t:r.pdf<CR>
```

Zathura automatically refreshes the view whenever changes to an open document is detected. This means that I can open a `.slides` file in Vim, save changes, and press `Z` to view my changes in Zathura. I can then immediately view any additional changes I make in the open Zathura window, just by saving the `.slides` file.
