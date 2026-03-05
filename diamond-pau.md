Skip to content
Anyone with a Notion account can comment on this page.
Sign up or login to comment
Laniakea Workspace
📦
Projects
💎
Diamond PAU
💎
Diamond PAU
View details
Content
Questions
Risks
Blocked by
Blocking
Sub Items
Parent item
Properties
Status
In Progress
Health
On track
Type
Smart Contracts
Date
January 1, 2026 → May 31, 2026
Blocked by
Empty
Blocking
📦
Configurator-unit
📦
NFAT Contracts
Project Lead
👤
Lucas Manuel
Project Team
PullUp
Spark
Key Stakeholders
Smart Contract
Vector
Tensor
Operations Team
Soter Labs
Product Owner
Empty
Strategic Owner
👤
Deniz
Sub Items
Empty
Subject Matter Experts
Empty
Success Criteria
Empty
Completion
Empty
Initiative
Phase 1
Origin
Laniakea Docs
Sub-initiative
1.1 – Diamond PAU
Description
The upgraded smart contract architecture that replaces the legacy PAU (Parallelized Allocation Unit) for each Prime. Diamond PAU uses the EIP-2535 "diamond proxy" pattern — modular pieces called facets that can be added, removed, or upgraded independently. This mitigates the need for redeploying the entire ALM Controller each time you want to add a new allocation target. Critical component of Laniakea phase 1.
Technical Context
  • The upgrade happens in three stages: libraries > external contracts > generic dispatcher
  • Configurator-unit will only work with diamond PAU, not legacy
  • Position data stays in ALMProxy, so no interface change for integrations.


Business Need
Empty
Acceptance Criteria
  • Diamond PAU stage 3 double audited
  • Diamond PAU deployed for Spark, Grove and Obex(?)

The following facets are available: 
  •  NfatDepositFacet — deposit into NFAT queues
  •  NfatWithdrawFacet — withdraw before deal execution
  •  All facets related to existing integrations for Grove, Obex and Spark
Out of Scope
Empty
Comments
Deniz Yilmaz
Feb 20
@Jeppe Stenbæk I filled out the fields above,  but what is the section below supposed to contain? 
Jeppe Stenbæk
1d
Currently the below, is C/P from the Laniakea Github repo, (just more context) as long as properties is filled in you are good 🙂
This document outlines all of the stages required to get to the diamond PAU upgrade being finalized. 
Staged Upgrade Approach
This all must be from spark-alm-controller v1.10.0 production release commit.
Stage 1: Library Refactor, Codebase Unification
Code changes
	
L


Test changes
	
XS


Deployment changes
	
S
Refactor all existing controller logic into external libraries, without changing behaviour. Add all logic from Grove’s divergent codebase so that Obex, Grove and Spark can all consume the same codebase. This release will be useful to ensure that the refactor can begin with minimal test changes (should be limited to initial configuration). This will reduce audit scope and make the upgrade path safer.
Codebase unification approach:
Manually diff each library against the audited code within each repo
Manually review each library as well to ensure that all logic looks correct
Stage 2: Library → Facet Transition, Registrar introduction
Code changes
	
M


Test changes
	
S


Deployment changes
	
L
Convert these libraries into standalone contracts and manually delegatecall into them from the controller.
In addition, all storage references in libraries and controller are moved into a centralized registrar contract per Star. PAU now becomes (Controller + RateLimits + ALMProxy + Registrar). This allows state to be persisted across upgrades instead of needing to perform state migrations. This also allows for the unification of constructors across Stars and between Mainnet and Foreign Controllers.
Stage 3: Diamond Standard Migration
Code changes
	
M


Test changes
	
S


Deployment changes
	
L
Refactor the controller to route delegatecalls via a Diamond-standard dispatch mechanism, replacing the manual wiring from Stage 2.
Why This Is the Right Approach
This staged path provides several key advantages:
Does not block product development
New integrations and business-driven functionality can continue to be added throughout the upgrade process, rather than waiting for a full parallel system to be production-ready.
Preserves our existing testing infrastructure
The current SLL test suite is extremely comprehensive and battle-tested. Leveraging it to assert behavioural equivalence at every stage is both safer and significantly less expensive than rebuilding coverage elsewhere.
Planner logic remains unchanged
The planner can remain completely stable throughout the migration, reducing engineering effort of managing multiple parallel systems.
Overall this approach achieves the desired business objectives with the most efficient use of engineering resources while ensuring a safe upgrade path.
Launch Timeline
This approach is simpler and more capital-efficient than a fully parallel rebuild, but it requires tighter coordination across Stars (Spark, Grove, Keel, Obex). The sequence below begins after Spark ships controller v1.10 (already on the roadmap and headed into the Feb 2 audit).
v1.11 - Stage 1: Library refactor + unify codebase - March 2 audit
Spark
Move all controller functionality into external libraries (no behaviour changes).
Consolidate any diverging logic from other Stars into a single shared controller codebase (currently spark-alm-controller), then rename to a more neutral repo (e.g., sky-pau).
All Stars
TBD: Upgrade controllers to the shared sky-pau controller implementation.
v1.12 - Stage 2: Libraries → delegatecall “facet-like” contracts - April audit
Spark
Convert the Stage 1 libraries into standalone logic contracts.
Migrate storage access to use a ParameterRegistry contract
Update the controller to manually delegatecall the logic contracts (explicit wiring; behaviour unchanged).
All Stars
TBD: Perform the same uniform upgrade (same pattern; shared contracts where applicable).
v1.13 - Stage 3: Diamond-standard dispatch - May audit
Spark
Replace manual delegatecall wiring with Diamond-standard selector routing in the controller.
Stage 2 logic contracts are used officially as facets (reused; no need to redeploy just for the dispatch change).
All Stars
Upgrade the controller to Diamond dispatch.
Configure only the subset of facets each Star needs for its PAU.
Deniz Yilmaz
Feb 20
cc for visibility @Peter Simon @Katarina Janec 
Parent item
