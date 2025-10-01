---
title: "From REINFORCE to R1: an Abridged Genealogy of Reinforcement Learning"
date: 2025-02-21T19:58:43-05:00
tags: ["ai"]
---

Starting from REINFORCE, the original deep reinforcement learning algorithm, we will trace the evolution of policy gradient methods to the Group Relative Policy Optimization algorithm used to train [Deepseek r1](https://github.com/deepseek-ai/DeepSeek-R1). 

This post ignores the LLM side of things, less-related developments in RL, and most of the equations used for these algorithms,  but captures the essence and intuition of the RL-timeline without wasting your time. This is all self-study, so feel free to send me any corrections/suggestions.[^1]

## Table of Contents

1. [Reinforcement Learning 101](#reinforcement-learning-101)
2. [REINFORCE](#reinforce)
3. [From REINFORCE to Actor-Critic](#from-reinforce-to-actor-critic)
4. [From Actor-Critic to Advantage Actor-Critic (A2C)](#from-actor-critic-to-advantage-actor-critic-a2c)
5. [From Advantage Actor-Critic to Proximal Policy Optimization (PPO)](#from-advantage-actor-critic-to-proximal-policy-optimization-ppo)
6. [From Proximal Policy Optimization to Group Relative Policy Optimization](#from-proximal-policy-optimization-to-group-relative-policy-optimization)


[^1]: I know I'm pretty loose with the notations--I prefer this to adding a ton of extra symbols that don't contribute much.

## Reinforcement Learning 101

Reinforcement learning is a subfield of machine learning that can learn without human data. Instead, an agent can learn through interacting with its environment by taking actions and receiving rewards based on its actions. The agent wants to maximize its reward.

Specifically, an environment at time $t$ with state $s_t$ sends an observation, $o_t$, to an agent, which produces probabilities to select an action, $a_t$, based on the observation. The environment transitions to a new state, $s_{t+1}$, and the agent receives a reward, $r_{t+1}$, based on the action it took. The agent's goal is to learn a policy, $\pi(a_t|o_t)$ that maximizes the expected sum of rewards, $R = \sum_{t=0}^T \gamma^t r_t$, where $T$ is the number of steps in the trajectory (sequence of states, actions, and rewards from the start to the end of an episode), and $\gamma$ is a discount factor, which reduces the value of rewards the farther into the future they are. There are ways to perform reinforcement learning without neural networks, but we will focus on deep reinforcement learning, where all policy actions are determined by a neural network with parameters $\theta$.

## REINFORCE

The original policy gradient, and the basis for all policy gradient methods, is the [REINFORCE](https://dilithjay.com/blog/reinforce-a-quick-introduction-with-code) algorithm. REINFORCE samples trajectories from the environment, which it uses to directly compute the gradient of the policy:

$$
\theta_{t+1} = \theta_t + \alpha R_t \sum_{t=0}^T \nabla_\theta \log \pi(a_t|o_t)
$$

where $\alpha$ is the learning rate, and $R_t$ is the remaining discounted reward--also called a return--from the current state given by $R_t = \sum_{t'=t}^T \gamma^{t'-t} r_{t'}$. 

REINFORCE simply "reinforces" the actions proportional to the reward they receive. This is the most intuitive reinforcement learning algorithm, but it has high variance, which leads us to actor critics.

I struggled with the concept of variance in RL for a while, but it's essentially the amount of randomness in the reward signal. When you are trying to learn purely from experience, rewards from a given state can vary wildly between trajectories depending on how the environment plays out, so we need a lot of samples to get a rough idea of what the "true" reward is for a given state. Actor-critic methods reduce this variance by using another neural network called a "critic" to estimate the value of a state. It turns out that using a consistent estimator, like a neural network, stabilizes learning, as the learning signal doesn't fluctuate as much between samples.

## From REINFORCE to Actor-Critic

As mentioned, actor-critic methods use neural networks to estimate reward. This results in more stable learning compared to using trajectories directly. The actor is just the policy from REINFORCE, and the critic is a new, separate network that estimates the return given the current policy. We won't cover the training of the critic here, but just assume it's just a neural network that takes observations $o_i$ as input and estimates the return $R$ for the actor.

At it's core, actor-critic is just REINFORCE, but $R_t$ is computed by another neural network, which is trained using the actual returns from the environment.

As a bonus, we can now update actors without requiring the full trajectory, since we are using an estimate instead of the true return.

## From Actor-Critic to Advantage Actor-Critic (A2C)

The next step in the evolution of policy gradient methods is the Advantage Actor-Critic (A2C) algorithm. Now we introduce the *advantage function*, which is the difference between the return and the value estimate of the state:

$$
A_t = r + \gamma V(o_{t+1}) - V(o_t)
$$

where $V(o_i)$ is the value estimate of the state computed by our critic at time $i$. 

The advantage function tells us how much better our action was compared to the expected action for that state, which allows us to reinforce actions based on how much they improve our expected reward. Conversely, this also discourages actions based on how much they decrease our expected reward. This is unlike prior methods, which might only positively (or negatively) reinforce actions based on the absolute reward they receive, not the relative reward. Without the advantage function, given an environment which only produces positive rewards, we might only reinforce good actions, without ever penalizing bad ones.

Now, the policy gradient is (roughly) computed as:

$$
\theta_{t+1} = \theta_t + \alpha A_t \sum_{t=0}^T \nabla_\theta \log \pi(a_t|o_t)
$$

where $A_t$ is the advantage function computed using the critic network. This further stabilizes learning.

## From Advantage Actor-Critic to Proximal Policy Optimization (PPO)

Skipping over many other developments, we jump directly from A2C to Proximal Policy Optimization (PPO). PPO uses the advantage function to update the policy, but just by a little bit, by introducing a *clipping* term that limits the size of the update. This prevents the policy from changing its behavior too much in a given update, which might otherwise destabilize training and cause the policy to forget some learned behaviors. 

PPO prevents behaviors from changing too much by ensuring that the probability of taking an action in a given state doesn't change too much, using a ratio of the new policy to the old policy, $\frac{\pi_\theta(a_t|o_t)}{\pi_{\theta_{\text{old}}}(a_t|o_t)}$. When the probabilities don't change, $ \frac{\pi_\theta(a_t|o_t)}{\pi_{\theta_{\text{old}}}(a_t|o_t)}= \mathbf{1}$, but if the probabilities change, $\frac{\pi_\theta(a_t|o_t)}{\pi_{\theta_{\text{old}}}(a_t|o_t)}$ will range between 0 and $\infty$. PPO clips the ratio to a range of $[1-\epsilon, 1+\epsilon]$, where $\epsilon$ is a hyperparameter we choose between 0 and 1 to determine the max percentage by which a probability can change.

The PPO update is then:

$$
\theta_{t+1} = \theta_t + \alpha \nabla_\theta \mathbb{E}_t \left[ \min( \frac{\pi_\theta(a_t|o_t)}{\pi_{\theta_{\text{old}}}(a_t|o_t)}
A_t, \text{clip}(\frac{\pi_\theta(a_t|o_t)}{\pi_{\theta_{\text{old}}}(a_t|o_t)} , 1-\epsilon, 1+\epsilon) A_t) \right]
$$

This adds a lot of terms to our update, but hopefully the jump from A2C to PPO is visible.

## From Proximal Policy Optimization to Group Relative Policy Optimization

Finally, we arrive at Group Relative Policy Optimization (GRPO), the algorithm used to train Deepseek r1. This algorithm is used strictly in language modeling, so the ability to update before the end of a sequence doesn't really matter; all that matters is the stability and efficiency. Unlike prior algorithms, GRPO's main contribution isn't that it further stabilizes learning, but that it reduces memory and computation requirements drastically.

Turns out, for language modeling, we don't actually need the critic network, which saves us 50% of the memory and computation required to run reinforcement learning. We can just take all the other non-critic enhancements since REINFORCE and apply them in large batches , which is what GRPO does.

$$
\frac{1}{G}\sum_{i=1}^G \frac{1}{|o_i|} \sum_{t=1}^{|o_i|} \min  \left[ \frac{\pi_\theta(o_{i,t}|q, o_{i,\lt t})}{\pi_{\theta_{\text{old}}}(o_{i,t}|q, o_{i,\lt t})} \hat{A}_{i,t}, \text{clip}\left(\frac{\pi_\theta(o_{i,t}|q, o_{i,\lt t})}{\pi_{\theta_{\text{old}}}(o_{i,t}|q, o_{i,\lt t})}, 1-\epsilon, 1+\epsilon\right) \hat{A}_{i,t} \right] - \beta D_{\text{KL}}\left[\pi_\theta \, \| \, \pi_{\text{ref}}
\right]
$$

You can see the lineage from PPO here. $q$ refers to a question, and $o$ here refers to an output sequence. $G$ is just the number of outputs in a a group. The main difference from PPO is that, instead of computing the advantage $A_t$ using a critic network, we now compute it within a group of sequences:

$$
\hat{A}_{i,t} = \frac{r_{i,t} - \text{mean}(\mathbf{r})}{\text{std}(\mathbf{r})}
$$

where $\mathbf{r}$ is the set of returns from the group of sequences. This replaces our neural estimate with an empirical estimate, while maintaining the benefits of the critic's stability.

There's a KL-divergence term at the end $\beta D_{\text{KL}}\left[\pi_\theta \, \| \, \pi_{\text{ref}}\right]$, which is ensures that the policy doesn't change too much from the fine-tuned policy, $\pi_{\text{ref}}$. 
