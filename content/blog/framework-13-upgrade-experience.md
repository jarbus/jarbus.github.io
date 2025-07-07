---
title: "My AMD Framework 13 Upgrade Experience"
date: 2025-07-07T08:55:26-04:00
---

Just upgraded my Framework Laptop 13 Mainboard from a Ryzen 7640U to a Ryzen AI HX 370. I run Arch Linux. Here's my experience:

* Upgrade was easy, but the cables for my WiFi card wouldn't snap into place. There's a plastic thing that I have to put on top of the connector to hold them in place, but it's a massive pain to connect. Took me over 20 minutes to align and lock the cables into place, but I got it working.

* The website said the HX 370 mainboard was only compatible with the RZ717 WiFi card, but the RZ717 was out of stock when I bought my mainboard. When the WiFi card was back in stock, they wouldn't let me buy it without buying *another* mainboard. This is stupid, and I suspect just an innocent oversight on their part. I had to install my RZ616 to see if that was good enough.

* On the new mainboard, the AMD RZ616 wifi card's drivers would disconnect me for hours at a time, essentially rendering my laptop unusable---not good when you're do coding interviews for a job. I reached out the customer support, they left me on read for about a week, so I just purchased an Intel AX210 non-vPro which works *perfectly*. That's what's great about a company like Framework: if their support is slow or unhelpful, you can fix your problems yourself.
    * I posted about my customer support experience on Reddit, and even though the post didn't blow up, their support lead reached out to make sure I was taken care of. They really do seem to care---sometimes things just fall through the cracks.
    * Even though their customer support was slow, the initial response was still promising. I probably would have been taken care of, just after a few more weeks.
    * I think they should stop selling the AMD RZ WiFi cards, given their issues. I wish their website just told me to get the Intel AX210 non-vPro when I was buying the laptop.
    * It only took a few days to get the Intel AX210 non-vPro, which was nice. I'd be a much less happy customer if that also took a month.

* Linux required some tinkering to get working, but ChatGPT was able to guide me through literally everything [^1]. I was literally dropping in the SSD from the previous mainboard without reinstalling, so I had some issues booting from the boot partition and needed to update `/etc/fstab`, so not an issue on Framework's end. Nothing a live USB couldn't fix.

[^1]: I could write volumes about how useful ChatGPT is for debugging Linux issues. I generally know what I'm doing, I just don't know the syntax for most of the commands. AI has read every single Linux question on the internet and is really *really* useful for identifying problems and suggesting solutions.

* It's so cool how I don't need to wait for a screwdriver from Amazon to replace any of the parts. Keep the included screwdriver in your backpack and you're always good to go.

* Their documentation is *excellent*. Related: [Take the Road Most Documented](/blog/take-the-road-most-documented)

Overall, these shortcomings are to be expected from a small, growing company. The important thing is that there was a documented, non-hacky solution I could find and implement on my own. The actual upgrade was easy, the HX 370 mainboard is *fantastic*, and everything now works flawlessly.

Overall: 9/10 experience, would buy again. 
