---
title: "Bitcoin Whitepaper, Explained"
date: 2020-01-03T11:25:49-04:00
tags: ["technology"]
---
## Introduction {#introduction .unnumbered}

In this essay we will give a brief history of crytocurrency leading up to
Bitcoin, give an overview of the Bitcoin protocol by summarizing
key sections of the whitepaper, and briefly discuss Bitcoin's use of cryptographical
proof and computational security instead of trusted third parties within
the protocol.

## History {#history .unnumbered}

Bitcoin is far from original. Digital currencies date back as far as
1982, where David Chaum released a paper called \"Blind Signatures\",
which formed the basis of a digital currency known as eCash. In 1996,
Douglass Jackson created a currency known as e-gold in 1996, the first
currency to reach mass adoption at over 3.5 million accounts.
Many other subsequent currencies rose and fell before Bitcoin gained
stable footing, including projects such as BitGold and b-money.

Blockchain technology development began as early as 1991 when Stuart
Haber and W. Scott Stornetta began work on a cryptographically secured
chain of blocks. [Their inital goal was to implement a system where
document timestamps could not be tampered with.](https://link.springer.com/content/pdf/10.1007%2F3-540-38424-3_32.pdf) Bitcoin builds upon
Haber and Stornetta's subsequent work of reliable timestamping and
securing names for bit strings and cites three of their papers,
making up a third of the nine citations in the Bitcoin whitepaper.

Bitcoin also builds upon technology such as Proof-of-Work, first
developed in 1997 by Adam Back under the name [Hashcash.](http://hashcash.org/)
Proof-of-Work is a counter-measure towards abuse of un-metered internet
resources which could enable a Denial of Service attack on email by
requiring an attacker to expend computational resources in order to
interact with the network. A reusable version of Proof-Of-Work was
further developed by Hal Finney in 2004, the receiver of the first
bitcoin transaction. Proof-Of-Work will be further discussed later on in
this paper.

Satoshi Nakamoto, the anonymous creator(s) of Bitcoin released the
Bitcoin whitepaper to a cryptography mailing list on October 31st, 2008,
four short years after Hal Finney's paper. The first block was mined
January the following year, with a comment that reads:


> "The Times 03/Jan/2009 Chancellor on brink of second bailout for banks"

Very fitting for the anti-authority ideals Bitcoin would spur in the coming years.

## Design {#design .unnumbered}

### Section 2 and 9: Transactions, Combining and Splitting Value {#section-2-and-9-transactions-combining-and-splitting-value .unnumbered}

Bitcoin is represented as a publicly visible global log of
[signed](https://en.wikipedia.org/wiki/Digital_signature)$^W$
transactions. Each transaction denotes the participants in a transaction
as well as the amount of money transfered (analogous to the Venmo public
feed), and the signature ensures the account publishing the transaction
is the account who owns the Bitcoin. Since the amount of Bitcoin an
account has is directly represented by outputs of previous transactions,
sending money is represented by taking previous transactions addressed
to your account, sigining them, and specifying which addresses will
receive which portions of the funds. Since one or more transactions can
be used as input for this process, there can be one or more addresses
receiving the output, including the spender who recieves any left-over
Bitcoin as change, since it's impossible to use a fraction of a
transaction as input.

Transactions must be verified, i.e. nodes must confirm that transaction
signatures come from their corresponding private keys. Transactions are
verified in large batches. Each transaction is added to a pool of
unverified transactions, which are then all verified and published to
the network in a block, approximately once every ten minutes. Each block
is published with a timestamp and a hash of a previous block, forming a
"chain" of all valid transactions.

### Sections 3 and 4: Timestamp server, Proof of Work {#sections-3-and-4-timestamp-server-proof-of-work .unnumbered}

Bitcoin also implements a distributed timestamp server. Normal timestamp
servers take hashes of previous timestamps and the current block in
order to form a new timestamp hash, then widely publish this hash.
However, this requires a trusted party, and does not work in a
distributed setting with no trusted parties.

Nakamoto takes inspiration from Adam Back's Hashcash algorithm, which
implements a Proof-Of-Work scheme based off of finding a hash with a
specific number of zeros at the beginning. This is a very
computationally expensive task, as the only method of obtaining such a
hash is brute force. Since a new block is published every ten minutes
and each block requires the hash of a previous block, this requires
anyone attmempting to modify the blockchain history to not only find the
proper hash at the specific time, but also all hashes of subsequent
blocks in order to maintain the validity of the ledger. This type of
attack can be used to spend the same Bitcoin twice, as a user could make
a transaction, erase it from the blockchain, and then use it again.
However, thanks to the proof-of-work algorithm, this attack increases in
difficultly exponentially as new blocks are added, and is one of the
many forms of computational security the Bitcoin protocol implements.
Since the amount of computational power on the blockchain will naturally
vary overtime, the proof-of-work algorithm will also adjust to
compensate for increased/decreased mining power in order to keep blocks
published approximately every ten minutes.

The first block verified and published is added to the network, and the
longest chain of blocks is deemed to be the correct one.

### Section 5: Network {#section-5-network .unnumbered}

The Bitcoin network runs on the following steps taken verbatim from the
original whitepaper, as there is not much summary for this section I
deem myself capable of doing better than Nakamoto.

1.  New transactions are broadcast to all nodes
2.  Each node collects new transactions into a block
3.  Each node works on finding a difficult proof-of-work for its block
4.  When a node finds a proof-of-work, it broadcasts the block to all nodes
5.  Nodes accept the block only if all transactions in it are valid and
    not already spent
6.  Nodes express their acceptance of the block by working on creating
    the next block in the chain, using the hash of the accepted block as
    the previous hash.

Nodes always consider the longest chain to be the correct one and will
keep working on extending it.

### Sections 6-8: Incentive, Reclaiming Disk Space, Simplified Payment Verification {#sections-6-8-incentive-reclaiming-disk-space-simplified-payment-verification .unnumbered}

Section six explains the financial benefits of mining, namely how miners get newly minted coins and transaction fees.
Nakamoto then explains how even when an adversary can claim control over a majority of the network's mining power, it makes economic sense to act according to the protocol to gain profit instead of creating double-spend attacks, since people will stop using the system once it is compromised.

In section seven, Nakamoto also discusses storage optimizations for
reducing the amount of disk space the entire blockchain uses. The
primary method discussed involved removing transactions that are buried
underneath many blocks but hashing the transactions in a Merkle tree as
to break the hashes of any blocks.

In section eight, Nakamoto describes a method of payment verification
without needing to run a full node, as well as potential attacks and
countermeasures on nodes attempting to verify transactions without
storing the entire blockchain.

### Section 10: Privacy {#section-10-privacy .unnumbered}

It should be noted that Bitcoin has no privacy protections in place to
protect users besides basic anonymity of not tying real-world identities
to keys. The amount of Bitcoin sent in each transaction is public, as
well as the public keys used. New public-private keypairs are
recommended for each transaction, but the multi-input nature of
transactions reveals two inputs are attached to the same owner. As a
result, if the identity of a sender is compromised, it's possible to
trace transaction history and link previous transactions that user has
made.

### Section 11: Cryptography and Security {#section-11-cryptography-and-security .unnumbered}

Attackers are unable to steal the money of other users without their
private key. There is also no method to generate new Bitcoin in anyway
that an honest node could recognize as valid. Therefore, the only
feasible attack on Bitcoin is to generate an alternative chain of
blocks. Since the longest chain of blocks is considered valid, this
attack requires the generation of an alternative chain faster than the
honest chain. This can be thought of as a race between the attacker and
the rest of the network, with the attacker starting from behind since
they have to re-compute proof of work for existing blocks.

Nakamoto demonstrates how an attacker with $51\%$ of the networks hashing power
will be guaranteed to eventually catch up and sustain an alternative
chain, however given a sufficiently large network Nakamoto assumes this
infeasilbe, as the computation power required would be enormous.
Additionally, every time an adversary fails to beat an honest node in
creating the next block, the amount of blocks they need to catch up to
increases and thus unless an attacker gets incredibly lucky when they
first start generating an alternate chain, their chances of catching up
to the main chain decreases exponentially. Since the chance for an
attacker to catch up to the honest chain decreases exponentially as new
blocks are added, Nakamoto demonstrates how long an honest recipient
must wait before they can be 99.9% certain a double-spend attack will
not happen given attackers of various computational power. For example, if attackers
control 10% of the mining power, one would need to merely wait five
blocks, but if attackers have 45%, one would need to wait 340 blocks,
or just under two and a half days, to be sure their transaction is safe.

### Resources Used

Of course the [Bitcoin whitepaper](https://bitcoin.org/bitcoin.pdf) and it's references have been used in the writing of this essay, but I also wanted to credit [this Quora post](https://www.quora.com/What-came-before-bitcoin) for pointing author in the right direction for the second section.
