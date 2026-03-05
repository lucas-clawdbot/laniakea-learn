# Laniakea Deep Dive — Podcast Script
# Target: ~20 minutes (~3000 words)
# Voice: Onyx (OpenAI TTS)
# Style: Single host, conversational but authoritative

---

Welcome to the Laniakea deep dive. If you're heading into a Sky Ecosystem offsite and want to sound like you actually read the docs, this is your twenty-minute crash course. Let's get into it.

## What is Sky Ecosystem, really?

Let's start with the basics. Sky Ecosystem powers USDS — a large decentralized, yield-generating stablecoin. As of late 2025, we're talking about roughly ten billion dollars in USDS supply, over four hundred million in annualized protocol revenue, and about a hundred and sixty-eight million in annualized profit. This thing grew around eighty-six percent in 2025, outpacing the overall stablecoin market which grew about fifty percent. So it's not just big — it's growing faster than the category.

Sky evolved from MakerDAO, which launched back in 2017 with DAI. Eight years of continuous operation through multiple market cycles — the 2018 bear market, the March 2020 crash where ETH dropped over fifty percent in a single day, the 2022 crypto winter. That track record matters. DAI still works and is convertible one-to-one with USDS.

The revenue model is straightforward. Sky earns a base rate on deployed capital, pays a savings rate to sUSDS holders, and keeps the spread. Revenue comes from collateralized lending, treasury positions, private credit, and delta-neutral strategies. Diversification means they're not dependent on any single market regime.

## The Token System

Three tokens to know. USDS is the stablecoin — pegged one-to-one to the dollar, overcollateralized, freely transferable, available on Ethereum mainnet plus multiple L2s via something called SkyLink. Unlike payment stablecoins, USDS is specifically designed for capital formation and yield generation.

sUSDS is the savings token — it's an ERC-4626 vault. You deposit USDS, get sUSDS back, and the exchange rate increases continuously at the Sky Savings Rate. No lockups. It even earns yield on other chains.

SKY is the governance token. There are 23.46 billion total, emissions are permanently disabled, and the protocol buys back SKY on the open market using profits. Since February 2025, over ninety-two million dollars in buybacks — that's over six percent of total supply. SKY holders get three things: governance participation, programmatic profit allocation through those buybacks, and the ability to use staked SKY as collateral for borrowing USDS while still earning staking rewards. That last one is clever — you borrow cheaper without sacrificing governance participation or yield.

Roughly seventy-five to a hundred percent of protocol profits flow to SKY stakers through the buyback mechanism. There's also a deflationary mechanic: about fourteen percent of the original MKR supply was never claimed, and the SKY backing that unclaimed MKR gets burned one percent per quarter over about twenty-four years.

## The Treasury Management Function

Protocol revenue flows through a five-step waterfall called the TMF. Step one: security and maintenance — twenty-one percent during the genesis period, dropping to four to ten percent later. Step two: aggregate backstop capital — a solvency buffer targeting one-and-a-half percent of total supply. Step three: the Fortification Conserver — legal defense and resilience. Step four: the Smart Burn Engine — those SKY buybacks we talked about. Step five: everything left goes to staking rewards. Steps three and four scale up with a hyperbolic function tied to total net revenue, so as the protocol earns more, more goes to burn and legal defense.

## The Agent Network — This is Key

Now here's where Laniakea really gets interesting. The Agent Network is a capital allocation layer sitting between Sky Protocol and actual investments. The flow goes: Sky Protocol, to Primes, to Halos, to end assets.

Primes are the primary capital deployers. Think of them as governance-approved operators that receive capital from Sky Protocol and deploy it into strategies. Each Prime has its own treasury, its own governance token, and a specialized focus. Right now there are three operational Star Primes: Spark handles DeFi lending across six chains, Grove does private credit and CLO allocations, and Keel handles ecosystem expansion including Solana. There's also an Institutional Prime called Obex for incubation.

The beautiful thing is that Primes compete for capital. The one with the best risk-adjusted returns gets more allocation. This creates market pressure for optimization — better yields, risk specialization, innovation, and efficiency.

Halos are investment product wrappers created by Primes. Each Halo wraps a specific strategy and provides standardized interfaces. There are three main types.

Portfolio Halos use something called LCTS — Liquidity Constrained Token Standard. It's a queue-based system. You subscribe, wait in a queue, and at daily settlement your deposit converts to Halo shares at the current exchange rate. This handles capacity-constrained strategies where you can't just dump unlimited capital in.

Term Halos use NFATs — Non-Fungible Allocation Tokens. These represent individual bespoke deals with negotiated terms. Each position can have different duration, size, and yield. Think six-month, twelve-month, eighteen-month positions with different yields, all under the same legal framework. NFATs are transferable and can be used as collateral.

Trading Halos run AMM smart contracts to provide instant liquidity for RWA tokens. Users sell tokenized real-world assets for instant USDS at a spread, and the Trading Halo redeems with the issuer over the normal cycle.

There are also Special Halos for identity networks, exchanges, and personal growth staking.

Then there are Core Halos — legacy assets like Morpho vaults, Aave pools, and SparkLend positions that get wrapped with the same risk framework and reporting standards as everything else. This is the migration path for existing protocol positions.

## Risk Management — Basel III for DeFi

The risk framework is genuinely sophisticated. It's inspired by Basel III banking regulation but adapted for decentralized operation. The core insight: capital requirements should reflect the maximum loss that could actually be forced to realize, not mark-to-market volatility.

There's a two-tier capital structure. Junior Risk Capital absorbs losses first in exchange for higher returns. Senior Risk Capital is protected by the JRC buffer and gets lower but safer returns. Each Prime provides its own JRC from its treasury — skin in the game. They lose their own capital first.

The loss absorption waterfall goes deep. At the Prime level: first, the Prime's own capital takes the first ten percent of JRC losses. Then all junior capital shares in. Then the Prime's governance token gets diluted. At the system level: senior risk capital absorbs. Then SKY gets diluted. Nuclear options include genesis capital haircuts and, in absolute extremis, USDS peg adjustment. The idea is you'd never reach those last two.

Duration matching is clever. Sky tracks how long USDS holders actually keep their positions using a Lindy model — the longer you've held, the longer you're likely to keep holding. This liability duration data determines how much long-duration asset exposure is safe. Assets get matched to liabilities: if an asset takes a long time to liquidate, it needs to be backed by long-duration liabilities. Unmatched assets need extra capital for potential mark-to-market losses.

There's a risk capital ingression system that determines how much external capital actually counts. Not all capital gets full credit — it's discounted based on whether the provider is synomic, how long the capital is committed, and the Prime's existing composition. This prevents leverage from getting out of hand.

Concentration limits prevent overexposure to any single correlated risk type. Anything exceeding a category cap requires one hundred percent capital coverage. And there's operational risk capital on top — covering things like settlement timing exposure and warden economics.

## The Smart Contract Architecture

Every capital flow layer uses the same building block: the PAU — Parallelized Allocation Unit. A PAU has three components: a Controller as the entry point, an ALMProxy that holds funds and executes calls, and RateLimits for linear replenishment rate limits. Same contracts everywhere, just different configuration.

There are four layers. The Generator layer interfaces with the stablecoin contract. The Prime layer receives capital from Generators and deploys to Halos or bridges to other chains. The Halo layer deploys to RWA strategies and custodians. And the Foreign layer runs identical infrastructure on alt-chains.

The Diamond PAU pattern uses EIP-2535 diamond proxy architecture — modular, upgradeable functionality. You can add new action facets without full redeployment. This is the foundation for factory deployment in later phases.

Rate limits are the universal control mechanism. Every single capital flow is rate-limited with governance-set bounds. Losses are reflected instantly via exchange rate haircuts, while gains accrue gradually.

## The Beacon Framework and Sentinels

Laniakea introduces autonomous operations through beacons, classified on two axes: power and authority. Low Power, Low Authority beacons do reporting. Low Power, High Authority beacons execute deterministic rules. High Power, Low Authority beacons handle trading. High Power, High Authority beacons are the Sentinels — AI-capable formations.

Phase 1 starts with the simple deterministic beacons. Later phases introduce Sentinel formations with three components: Baseline for execution, Stream for intelligence, and Warden for safety.

## The Roadmap

There are eleven phases, zero through ten. Phase zero handles Grove's pre-standardization deployments — acknowledged technical debt. Phase one establishes MVP infrastructure: Diamond PAUs, the Configurator, NFAT infrastructure, and basic beacons. Phase two formalizes monthly settlement. Phase three transitions to daily settlement — a twenty-one hour active window plus a three hour processing window, settling at sixteen hundred UTC every day.

Phase four launches LCTS with srUSDS as the first product — senior risk capital tokens that anyone can hold. Before auctions come online, Core Council manually manages the srUSDS rate.

Phases five through eight are the factory phases. Phase five builds the Halo Factory for automated Halo creation. Phase six deploys the Generator PAU with single-ilk architecture. Phase seven adds the Prime Factory. Phase eight completes with the Generator Factory.

Phase nine activates Sentinel Base and Warden formations plus sealed-bid auctions where Primes compete for senior risk capital capacity. Phase ten brings Sentinel Stream for continuous operations.

The progression is deliberate: foundational infrastructure first, then factory systems for scale, then full automation with AI-capable Sentinels.

## Governance Transition

Post-Laniakea, governance evolves from direct SKY token executive votes to a layered SpellGuard model. Three layers: SpellCore requires a Core Council Guardian vote with a sixteen-of-twenty-four hat. Prime SpellGuard adds a Prime token vote on top. Halo SpellGuard adds a Halo token vote.

Every level needs dual-key authorization — a top-down payload from the layer above and a bottom-up token hat from the level's own holders. SKY holders retain ultimate sovereignty through a graduated freeze mechanism that can escalate to a full override, dismissing the Core Council entirely and reverting to direct SKY holder control.

## Trading Infrastructure

Sky Intents is an intent-based trading system. Users express what they want to trade, Exchange Halos handle price discovery and matching off-chain, and settlement happens on-chain atomically. Trading Halos complement this with always-on AMM liquidity. Prime Intent Vaults isolate trading capital from main treasuries, limiting blast radius if something goes wrong.

Identity Networks handle regulated products — on-chain registries of KYC-verified addresses. Token issuers configure which networks their tokens accept, and restrictions flow through automatically to any exchange or protocol using those tokens.

## Why This Matters

Here's the synthesis. Sky Ecosystem is building what is essentially a decentralized investment bank. The Agent Network creates competitive pressure that should drive returns higher. The risk framework brings banking-grade discipline to DeFi. The factory system means rapid scalable deployment of new products. And the Sentinel network will eventually automate ninety-nine percent of operations.

The competitive moat is the combination: eight years of uninterrupted operation, ten billion in USDS supply, a diversified revenue base, and now infrastructure that can scale capital deployment across chains and asset classes with institutional-grade risk management.

If someone asks you what Laniakea is, the one-liner is: it's Sky's infrastructure for automated capital deployment at scale, combining Basel III-inspired risk management with autonomous beacon and sentinel operations, enabling the protocol to efficiently deploy billions across DeFi, private credit, and real-world assets through a competitive agent network.

That's your twenty-minute deep dive. Go make it count at the offsite.
