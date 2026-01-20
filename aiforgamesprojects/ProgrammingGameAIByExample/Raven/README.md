# Raven — Goal-Driven Game AI Systems (Godot 4)

## Project Overview
**Raven** is a ground-up recreation of the goal-driven agent AI system from *Programming Game AI by Example*, implemented in **Godot 4 (GDScript)**.

The project focuses on engine-level AI architecture rather than gameplay polish. 
Core systems such as navigation, collision, perception, and decision-making are rebuilt from first principles instead of relying on Godot’s built-in navigation, physics, or AI frameworks.

AI behaviour emerges through the interactions of the subsystems and the steering behaviours.

The project serves both as:
- A practical study of classic game AI architecture
- A systems-engineering exercise emphasizing performance, debuggability, and reproducibility

## Core AI Concept
At the heart of Raven is a **goal-driven agent architecture**.

Each AI-controlled agent continuously evaluates a set of competing high-level goals (evaluators). On each arbitration cycle, the agent selects the most desirable goal and decomposes it into smaller subgoals until reaching atomic, actionable behaviours.

The system is based on the **Composite design pattern**, allowing goals to be:
- Hierarchical
- Stack-based
- Explicitly traceable during execution

This makes agent behaviour inspectable, tunable, and deterministic.

---

## High-Level Flow
1. **Goal Arbitration**
   - The agent’s Brain evaluates available goal evaluators (e.g. Explore, Attack, Get Weapon).
   - The most desirable goal is selected based on world state and fuzzy scoring.

2. **Goal Decomposition**
   - Composite goals push subgoals onto a stack.
   - Atomic goals execute concrete actions (move, shoot, pick up item).

3. **Navigation & Movement**
   - A valid path is requested from the navigation graph.
   - The agent follows the path using weighted steering behaviours.

4. **Perception & Memory**
   - Agents track visible entities using line-of-sight checks.
   - Sensory memory stores last-seen positions with time-based decay.

5. **Combat & Weapon Selection**
   - Fuzzy logic selects the most effective weapon based on distance, ammo, and context.

---
## Goal System
- Each agent owns a **Brain** responsible for arbitration.
- Goals are implemented as a composite tree:
  - **Composite Goals** manage sequencing and child goals.
  - **Atomic Goals** execute direct actions (movement, firing).
- Goals are processed using a regulated update cadence to control CPU cost and behavioural stability.

**Example**

- The Brain selects *Attack Target* as the most desirable evaluator.
- `Goal_AttackTarget` is pushed onto the goal stack.
- This composite goal adds subgoals such as:
  - `MoveToPosition`
  - `ShootAtTarget`
- Once all subgoals complete, control returns to the Brain.

---
## Navigation System
Raven uses a **custom node-based navigation graph**, built directly from a grid-aligned world.

- Nodes represent traversable or semantic locations (walls, items, spawns).
- Edges connect reachable nodes using adjacency lists.
- Node IDs are contiguous to improve cache locality and simplify precomputation.

### Pathfinding
- **Dijkstra** and **A\*** are implemented using min-heap priority queues.
- Heuristics are used for both pathfinding and AI decision evaluation.
- Optional **all-pairs cost tables** can be precomputed offline during map save.

### Movement
Navigation is split into two phases:
1. **Global pathfinding** (graph search)
2. **Local steering** (seek, arrive, wall avoidance)

This separation ensures efficient routing without sacrificing smooth motion.

---

## Fuzzy Logic

Fuzzy logic is used to handle uncertain or continuous decision-making, primarily in **weapon selection**.

Rather than fixed thresholds, desirability scores are computed from fuzzy sets such as:
- Distance to target
- Ammo availability
- Weapon effectiveness

Each factor contributes to a weighted score, allowing agents to adapt naturally to changing combat conditions.

---

## Collision & Line-of-Sight

Raven deliberately avoids Godot’s physics engine in favour of a **deterministic, CPU-only collision system**.

- Wall geometry is derived directly from grid data.
- Broad-phase collision uses spatial buckets keyed by grid cell.
- Narrow-phase tests include:
  - Line–segment intersection (vision, LOS)
  - Circle–circle tests (agents, projectiles)

This guarantees:
- Reproducible results
- Predictable performance
- Tight integration with AI perception

Many of the math foundations were implemented with reference to *Beginning Math and Physics for Game Programmers*.

---

## Map Editor & Tooling

Raven includes an **in-engine grid-based map editor** to support rapid iteration.

- Walls, items, and spawn points are authored directly in-engine.
- Maps serialize to human-readable JSON.
- Precomputed navigation costs are stored explicitly.
- Loading a map reconstructs:
  - Navigation graph
  - Collision geometry
  - Spatial buckets
  - Items and spawn points

All tooling uses the same data structures as runtime systems — no editor-only shortcuts.

---

## Design Constraints & Goals

This project was developed under explicit constraints:

- **Determinism** — identical inputs produce identical outcomes
- **Fixed update budgets** — AI and perception run within regulated intervals
- **Explicit data flow** — no hidden engine state
- **Inspection over abstraction** — systems are transparent and debuggable
- **Tool-driven iteration** — no external editors or preprocessing

Tradeoffs are intentional and documented, favouring clarity and correctness over maximal flexibility.

---

## References

- *Programming Game AI by Example* — goal-based architecture and Raven inspiration
- *C# Data Structures and Algorithms* — adjacency lists, graph traversal, heap-based search
- *Beginning Math and Physics for Game Programmers* — collision and intersection math

---
