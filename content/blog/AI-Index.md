---
title: "AI Index"
date: 2021-03-19T11:25:49-04:00
katex: true
tags: ["technology", "ai"]
---
An ever-expanding list of concepts in the field of AI to give myself and others an easy reference.
Each item in the list contains a short, rudimentary definition I've written, as well as a link to a resource that can explain it better.

[Ablation Study](https://stats.stackexchange.com/questions/380040/what-is-an-ablation-study-and-is-there-a-systematic-way-to-perform-it):
Removing some parts of a machine learning model to measure impact on performance

[Advantage Function](https://mc.ai/advantage-function-in-deep-reinforcement-learning/): The difference between a Q-value for a state-action pair and a value for the state. Useful to determine how good an action is relative to its state.

[Attention](https://towardsdatascience.com/intuitive-understanding-of-attention-mechanism-in-deep-learning-6c9482aecf4f): Neural networks are able to "pay attention" to specific parts of input or output, useful in translating languages or predicting sequences. For example, when trying to predict the next word in "the clouds in the", you pay attention to the word *cloud* to predict the word *sky*

[Autoencoder](https://en.wikipedia.org/wiki/Autoencoder)<sup>W</sup>: A type of neural network that attempts to take raw data, convert it into a simpler representation (usually by limiting the amount of nodes in a hidden layer for representation), and then decode the representation back into it's data. They are primarly used to extract the useful properties from data automatically. They can do this in an unsupervised fashion, since their output targets are the given input, requiring no labeling.

[AutoML](https://en.wikipedia.org/wiki/Automated_machine_learning)<sup>W</sup>: Systems where the entire machine learning process, from data preparation to network design, is automated.

[Autoregression](https://machinelearningmastery.com/autoregression-models-time-series-forecasting-python/): A time series model that uses observations from previous time steps to predict the value at the next time step.

[Backpropogation](https://en.wikipedia.org/wiki/Backpropagation)<sup>W</sup>: The algorithm and calculus behind gradient descent traditionally used in feed-forward neural networks

[Bayesian](https://en.wikipedia.org/wiki/Bayesian_statistics): An interpretation of probability where the phrase "probability" expresses a degree of belief between 0 or 1, 0 representing false and 1 representing true. Uses expected values and random variables.

[Bootstrapping](https://en.wikipedia.org/wiki/Bootstrapping_(statistics))<sup>W</sup>: Sampling from a distribution to approximate a function. In cases of reinforcement learning, bootstrapping usually samples potential future values to approximate a current value.

[Convolutional Neural Network (CNN)](https://en.wikipedia.org/wiki/Convolutional_neural_network)<sup>W</sup>: A neural network primarly used for image processing. These networks design filters for specific parts of an image to extract higher level information, filters such as detecting a certain type of edge.

[Covariate Shift](https://www.quora.com/What-is-Covariate-shift?share=1): The training distribution changes but the testing distribution does not change

[Data Mining](https://en.wikipedia.org/wiki/Data_mining): Discovering knowledge and patterns from massive amounts of data, usually in an unsupervised fashion.

[Deep Learning](https://en.wikipedia.org/wiki/Deep_learning)<sup>W</sup>: A subset of machine learning with a multi-step learning process, usually referring to neural networks with two or more layers.

[Discount Factors](https://stats.stackexchange.com/questions/221402/understanding-the-role-of-the-discount-factor-in-reinforcement-learning): A variable (usually $\gamma$) that determines how much a model cares about rewards in the distant future compared to immediate rewards.
  - $\gamma = 0$ cares only about immediate reward,
  - $\gamma = 1$ cares only about sum of all future rewards.

[Eligibility Trace](https://towardsdatascience.com/eligibility-traces-in-reinforcement-learning-a6b458c019d6): For temporal learning, the eligibility trace is a vector of decaying values that represent when weights were last used. When we encounter an error, this vector allows us to update recent weights harder than weights used long ago.

[Feed-forward Neural Network](https://en.wikipedia.org/wiki/Feedforward_neural_network)<sup>W</sup>: A simple neural network where information is passed strictly from one layer to the next.

[Generative Adversarial Network (GAN)](https://en.wikipedia.org/wiki/Generative_adversarial_network)<sup>W</sup>: A set of two or more neural networks that can generate new data based on existing training data.
A simple example is [https://thispersondoesnotexist.com/](https://thispersondoesnotexist.com/), that can generate fake pictures of humans.
    - GANs consist of one generator network with the goal to make realistic new data, and a distinction network with the goal to tell real data from fake. As the networks train, they each improve at their individual task, forcing their adversaries to improve in turn.

[Genetic Algorithms](https://en.wikipedia.org/wiki/Genetic_algorithm)<sup>W</sup>: Algorithms that try to mimic the evolutionary process by randomly modifying the best-performing sets of parameters while discarding those with the worst performance, then repeating.

[GPT-2/3](https://openai.com/blog/better-language-models/): A language model from OpenAI that can generate text that mimics a writing style incredibly well.

[Gradient Descent](https://en.wikipedia.org/wiki/Gradient_descent)<sup>W</sup>: An interative process that attempts to find a minimum of a function that works by moving in the direction that will decrease the gradient until a local minima is reached.

[Hyperparameters](https://en.wikipedia.org/wiki/Hyperparameter_(machine_learning))<sup>W</sup>: Manually defined parameters of the model, such as the size of a neural network, or manually defined parameters of the machine learning algorithm, such as learning rate.

[(IID) Independent and Identically Distributed](https://en.wikipedia.org/wiki/Independent_and_identically_distributed_random_variables)<sup>W</sup>: Random variables are independent and identically distributed when the value of one variable doesn't affect the probability of another variable. For example, the outcome of one coin flip does not affect the outcome of another coin flip, so both flips are IID.

[KL Divergence](https://dibyaghosh.com/blog/probability/kldivergence.html): Divergence between two distributions of data. Useful for determining how different fake data is from real data (GANs) or for determining how differemt two policies are for trust-based reinforcement learning.

[Level 0-5](https://en.wikipedia.org/wiki/Self-driving_car)<sup>W</sup>: The different "levels" of autonomy related to self driving cars. 0 represents full human control while 5 represents full vehicle control.

[Long Short Term Memory (LSTM)](https://en.wikipedia.org/wiki/Long_short-term_memory)<sup>W</sup>: A type of recurrent neural network that works exceptionally well with sequential input. A unique trait of these networks are their memory cells' "forget gates", which allow them to control how long they hold onto data for.

[The Lottery Ticket Hypothesis](https://deepai.org/publication/the-lottery-ticket-hypothesis-training-pruned-neural-networks): A randomly-initialized, dense neural network contains a subnetwork that is initialised such that — when trained in isolation — it can match the test accuracy of the original network after training for at most the same number of iterations.

[Markov Decision Process](https://en.wikipedia.org/wiki/Markov_decision_process)<sup>W</sup>: A system of states, actions, and probabilities of getting to other states given actions taken from previous states.

[Mode Collapse](https://aiden.nibali.org/blog/2017-01-18-mode-collapse-gans/): When the distribution of samples produced by a generative adversarial network represent a subset of the latent distribution, instead of the entire latent distribution. For example, you train a network to produce pictures of animals but it only learns to produce pictures of cats.

[Multi-armed Bandit](https://en.wikipedia.org/wiki/Multi-armed_bandit)<sup>W</sup>: A core component of reinforcement learning, the multi-armed bandit problem is the classic "exploration versus exploitation" tradeoff. In this problem, expected gain must be maximized in an environment with varying rewards, forcing an agent to decide between keeping an option they know to be safe versus exploring new options that might be better.

[Online/Offline Learning](https://stats.stackexchange.com/questions/897/online-vs-offline-learning): Online learning happens as data comes in. Offline learning happens after data is collected and made into a batch.

[Parametric & Non-Parametric Models](http://mlss.tuebingen.mpg.de/2015/slides/ghahramani/gp-neural-nets15.pdf): Parametric models use a finite number of parameters, like weights in linear regression, to represent a learned hypothesis. Non-Parametric models use variable/infinite/no parameters, like data points in nearest neighbors, to represent a learned hypothesis.

[Precision](https://en.wikipedia.org/wiki/Precision_and_recall)<sup>W</sup>: The fraction of relevant instances among the retrieved instances. Also known as positive predictive value.

[Recall](https://en.wikipedia.org/wiki/Precision_and_recall)<sup>W</sup>: The fraction of relevant instances that were retrieved. Also known as sensitivity.

[Recurrent Neural Network (RNN)](https://en.wikipedia.org/wiki/Recurrent_neural_network)<sup>W</sup>: A type of network that can store state, giving it a type of memory that can process a series of inputs. This can be accomplished by having a cycle within the network.

[Regression](https://en.wikipedia.org/wiki/Regression_analysis)<sup>W</sup>: A set of models that determine relationships between data and a dependent value. For example, linear regression tries to approximate a dependent value while logistic regression tries to determine the probability of a dependent value.

[Residual Neural Network](https://en.wikipedia.org/wiki/Residual_neural_network)<sup>W</sup>: Networks with connections that skip some layers and connect to non-adjacent ones. This type of network helps counter the vanishing gradient problem

[Reinforcement Learning](https://en.wikipedia.org/wiki/Reinforcement_learning)<sup>W</sup>: Algorithms are given a world state they are able to interact with, and learn from the reward their interactions give them.
  - [Model-Based](https://ai.stackexchange.com/questions/4456/whats-the-difference-between-model-free-and-model-based-reinforcement-learning): You create a model of the world and can predict what the next state and reward will be for each action
  - [Model-Free](https://ai.stackexchange.com/questions/4456/whats-the-difference-between-model-free-and-model-based-reinforcement-learning): You know what action to take without knowing what to expect, since you don't have a model of the world
  - [Value](https://www.freecodecamp.org/news/an-intro-to-advantage-actor-critic-methods-lets-play-sonic-the-hedgehog-86d6240171d/): Networks that determine the value of a state.
  - [Policy](https://www.freecodecamp.org/news/an-intro-to-advantage-actor-critic-methods-lets-play-sonic-the-hedgehog-86d6240171d/): Network to choose actions. Can directly optimize model instead of computing values, useful when you have a continuous action space. Only uses reward function. Requires a score function to evaluate performance of policy, usually total rewards accumulated given a period of time.
  - [Actor Critic](https://www.freecodecamp.org/news/an-intro-to-advantage-actor-critic-methods-lets-play-sonic-the-hedgehog-86d6240171d/): Backbone of state of the art reinforcement learning algorithms.
    - Uses a value-based Critic to measure how good the action taken is
    - Uses a policy-based Actor to to choose actions

[Stochastic](https://en.wikipedia.org/wiki/Stochastic)<sup>W</sup>: Randomly determined process, usually refers to probabilistic outputs of machine learning systems

[Supervised Learning](https://en.wikipedia.org/wiki/Supervised_learning)<sup>W</sup>: A model learns to produce a desired output and knows what that output is. Example: Image Recognition

[Temporal Difference](https://en.wikipedia.org/wiki/Temporal_difference_learning)<sup>W</sup>: Model-free reinforcement learning design which learns by bootstrapping value samples in order to approximate a value function. Once more information is revealed about the true value during later timesteps, you can update the low information bootstrapped guess by using the newly acquired outcome as a "ground truth" to train a network.
  - Temporal Difference error is the difference between consecutive temporal predictions.

[Trajectories](https://ai.stackexchange.com/questions/7359/what-is-a-trajectory-in-reinforcement-learning): The history of states (and potentially actions) taken during a walk of a Markov Decision Process.

[Transfer Learning](https://en.wikipedia.org/wiki/Transfer_learning)<sup>W</sup>: Taking parts of a network trained on one data set, and using it in a different network with a different dataset.

[Transformer](https://towardsdatascience.com/transformers-141e32e69591): A type of recurrent neural network primarily used with sequential data, like language translation. These networks use an attention model to improve performance.

[Unsupervised Learning](https://en.wikipedia.org/wiki/Unsupervised_learning)<sup>W</sup>: A model learns to produce a desired output without being told what it's looking for. Example: Playing Chess

[Vanishing Gradient Problem](https://en.wikipedia.org/wiki/Vanishing_gradient_problem)<sup>W</sup>: In a network, a gradient can become vanishingly small which will stop the weight from changing it's value, since weights are modified based on their contribution to the gradient.

Feel free to contact me with any suggested additions/changes at [jarbus@tutanota.com](mailto:jarbus@tutanota.com).
