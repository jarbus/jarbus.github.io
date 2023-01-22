---
title: "Unexpected Benefits of Testing Code"
date: 2023-01-21T18:38:43-05:00
---

Matthew Carlson's blog post ["Fighting Distraction With Unit Tests"](https://matthewc.dev/musings/unit-tests/) inspired me to share some extra benefits of writing test code I've discovered during my PhD program.

I'm working on a [weird project](https://github.com/jarbus/evotrade) that's constantly changing as I try new things, and naturally, debugging and ensuring correctness was a nightmare. So I started writing tests, cursing myself for needing to write so much code I'll likely throw away soon. But as it turns out, testing can be pretty helpful in a few other ways:

1. When I encounter a bug I didn't anticipate, I already have most of the code needed to reproduce it in a deterministic manner.
2. When I want to add/change functionality, I already have most of the code needed ensure that my changes work.
3. When writing new functionality, if I don't already have the code needed to make ensure it's working, I can write a small test that [runs whenever my code changes](https://timholy.github.io/Revise.jl/stable/user_reference/#Revise.entr). Making this test case auto-run on a second screen dramatically reduces the amount of time spent switching windows and lets me stay in my editor until the test passes. I highly recommend setting up a run-on-change system, it makes writing tests or designing plots pretty fun.
4. You can write tests for newer code by using tests for older code. This makes tests valuable as you develop, even if you plan to throw them out later.
5. I feel more confident about what my code is actually doing. As someone who is working in AI, the value of this is immense, as AI code can run without crashing but still be subtly incorrect.

I'm not writing an exhaustive test suite, or tests for edge-cases that shouldn't happen (asserts can deal with those). I'm writing code before I get bugs to spare myself the extra effort when I need to debug or make changes.
