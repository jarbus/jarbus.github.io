---
title: "Emergent Trade and Tolerated Theft Using Multi-Agent Reinforcement Learning"
date: 2024-02-04T12:14:25-05:00
tags: ["programming", "ai"]
---

I've been an author on a few papers before, but I recently published the first research project where I was responsible for most of the work and direction. It's in the first 2024 issue of the journal *Artificial Life*, which you can find [here](https://direct.mit.edu/artl/article-abstract/doi/10.1162/artl_a_00423/119154/Emergent-Resource-Exchange-and-Tolerated-Theft) (I'll post camera-ready paper here later this year, but for now, you can view the [pre-print on arxiv](https://arxiv.org/abs/2307.01862). Below, I tell the chronology of the project and summarize our findings.

![](/trade.gif)

We explore the conditions under which trade can emerge between four deep reinforcement learning agents that pick up and put down resources in a 2D foraging environment. Agents are rewarded for having both resources once, but the resources are distributed far apart from each other. To maximize reward, agents need to split up the work - agent 1 goes to resource A, agent 2 goes to resource B, etc, and then they meet to exchange resources, since meeting halfway can get them the most of each resource in the shortest amount of time.

I was working on this for a while in isolation, getting nowhere, and slowly going crazy. A few months later, Deepmind published a [paper](https://arxiv.org/abs/2205.06760) that explored this exact behavior---and found that agents could not discover how to exchange goods without programming a trading system into the game mechanics directly. I was getting similar results, but found that this trading behavior could emerge if I rewarded agents for being physically close to one another, which we'll call a "community bonus".

I reached out to the authors (great people btw), and they hypothesized that the trading behavior was a result of agents trying to keep each other alive to get the community bonus. In my setup, agents could die if they ran out of resources, so they were also keeping each other alive for company. The authors suggested I add some sort of "market", a place for agents to meet up and trade without getting directly rewarded for giving away resources for free. 

They explored similar ideas in their work, and if they couldn't get this behavior to emerge, what chance did I have? I needed to try something similar but sufficiently different.

Instead of adding a market where agents could come and go as they please, I added a campfire and a day-night cycle. I gave negative reward to agents for being out in the dark, which incentivizes them to gather around the campfire near others. Agents would only have enough time during the day to forage a single resource. 

As it turns out, agents really, *really* don't want to learn this behavior. It's easy for agents to get cheated out of the resources they offer by others who offer nothing in return, so they gather as much as possible on their own. They even forage at night if the darkness penalty isn't severe enough.

Eventually, after 4+ days of training time, agents start to realize that working together isn't so bad and land on a trading protocol where agents stand back, drop an offer, then walk over to collect the resources dropped by others. Experiments show that agents keep their distance initially so they can reclaim their offer if their trading partner attempts to cheat them.  

In one trial, agents converge on a local minimum, where agents 1&2 go to the same area to collect resource A, agent 3 goes to collect resource B, and agent 4 collects a bit of the other remaining resources. In this setting, we notice a behavior which we dub "Tolerated Theft". When agent 1 collects significantly more of resource A than agent 2, agent 2 tries to steal the resources exchanged between agents 1 and 3. To defend against this, agent 1 will drop some resources away from agent 3, to get agent 2 off their backs while they trade. This is particularly interesting, because an agent manages to "steal" resources without us adding a combat or larceny system. Nature truly does find a way.

I recommend checking out the [arxiv pre-print](https://arxiv.org/abs/2307.01862) if you are interested in the details and figures.
