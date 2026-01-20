# Raven — Game AI Systems & Engine-Level Architecture

## Overview
Raven is a ground-up reimplementation of the classic Raven AI project from Programming Game AI by Example, built in GDScript (Godot 4) with a strong emphasis on engine-level systems, deterministic simulation, and data-oriented design.

Rather than relying on built-in navigation, physics, or AI frameworks, this project reconstructs navigation, collision, perception, and goal-based decision-making from first principles. The result is a tightly integrated simulation where AI behavior emerges from explicit systems rather than opaque engine magic.

The project serves both as:
- A deep study of practical game AI architecture
- A systems-engineering exercise focused on performance, debuggability, and extensibility

## Design Constraints & Goals
This project was developed under several non-trivial constraints:
- Real-time performance — AI, navigation, perception, and collision all run within a fixed update budget
- Deterministic behavior — identical inputs produce identical outcomes (critical for debugging AI)
- Explicit data flow — systems communicate through well-defined structures, not implicit engine state
- Tool-driven iteration — maps, costs, and geometry are authored and validated inside the project
- Experimentation-friendly — AI decisions must be inspectable, reproducible, and tunable

## High-Level Systems
- Custom grid-based map editor
- Navigation graph with runtime path computation
- Deterministic collision and line-of-sight system
- Goal-driven AI agents with perception, memory, and arbitration
- Weighted steering behaviors layered on top of navigation

## Systems Overview
- [Navigation Graph](#navigation-graph)
- [Collision System](#collision-system)
- [Map Editor](#map-editor)
- [AI Agent System](#ai-agent-system)

## Architecture

```
+------------------+       +----------------------+       +--------------------+
|  Map Editor UI   | --->  | Map Serialization    | --->  | RavenWorld         |
| (MapDrawing/UI)  |       | (JSON in Maps/)      |       | - grid_world       |
+------------------+       +----------------------+       | - cell_buckets     |
                                                          | - RavenGraph       |
                                                          +----------+---------+
                                                                     |
                                                                     v
                                                            +------------------+
                                                            | AI Agents        |
                                                            | - GoalThink      |
                                                            | - SensoryMemory  |
                                                            | - Steering       |
                                                            +------------------+
```

## Subsystems

### Navigation Graph
**Problem**
Provide fast, consistent, and inspectable navigation for multiple agents in a dynamic grid world containing:
- Obstacles
- Items
- Spawn points
- Tactical choke points

The system must support:
- Repeated path queries
- Distance heuristics for AI evaluation
- Deterministic results independent of frame timing

**Approach**
A custom graph structure (RavenGraph) stores:
- Nodes as a contiguous array (RavenNode)
- Edges as adjacency lists keyed by node ID
Nodes are grid-aligned, typed (wall, traversal, spawn, item), and indexed for cache-friendly traversal

Pathfinding implementations:
- Dijkstra (single-source and precomputed variants)
- A* with Euclidean heuristic

All-pairs path cost tables (pre_calc_costs) are optionally computed offline during map save using parallel threads.

**Key Engineering Decisions**
- Contiguous node IDs → predictable memory access and simpler precomputation
- Adjacency lists over matrices → scalable and sparse-friendly
- Offline precomputation → eliminates runtime spikes during AI evaluation
- Explicit graph ownership → no dependency on engine navmesh internals

**Tradeoffs**
- Memory is deliberately traded for speed via pre_calc_costs
- Grid-based navigation sacrifices geometric freedom for determinism and simplicity
- Path costs are static per map (dynamic terrain would require partial recomputation)

### Collision & Line-of-Sight System
**Problem**
Support deterministic collision detection for:
- Agents
- Projectiles
- Vision occlusion

Without using Godot’s physics engine, while maintaining:
- Predictable performance
- Reproducible results
- Tight integration with AI perception

**Approach**
Wall geometry is derived directly from grid data
- Each wall cell generates line segments and outward normals
Broad-phase:
- Static spatial buckets keyed by grid cell
Narrow-phase:
- Line–segment intersection (LOS, vision)
- Circle–circle tests (agents, projectiles)
- No continuous physics — all math is explicit and CPU-only

Developed with reference to *Beginning Math and Physics for Game Programmers* by Wendy Stahler, especially for line intersection and circle intersection math.

**Key Decisions**
- Avoid physics engine → removes non-determinism and black-box behavior
- Use grid-derived geometry → guarantees alignment with navigation
- Separate static vs dynamic spatial buckets → reduces collision checks

**Tradeoffs**
- Grid-aligned walls limit geometric expressiveness
- Some LOS checks still traverse multiple buckets (acceptable at current scale)
- No impulse resolution — movement is steering-driven


### Map Editor & Tooling
**Problem**
Enable rapid iteration on AI scenarios without external tools, while guaranteeing:
- Navigation correctness
- Collision alignment
- Deterministic rebuilds

**Approach**
In-engine grid editor for:
- Walls, Spawn points, Items
Maps serialize to human-readable JSON, containing:
- Grid metadata
- Node definitions
- Precomputed navigation costs

Load step reconstructs:
- Graph
- Collision geometry
- Spatial buckets
- Items & spawns

**Key Decisions**
- Author once, consume everywhere → editor uses the same data as runtime
- Serialize precomputed data → no hidden runtime work
- Multithreaded precomputation → avoids blocking editor UI


**Complexity/Performance**
- Load time scales with node count and the size of precomputed cost tables.
- Save step runs Dijkstra for all traversal nodes; work is split across multiple threads.

### AI Agent System
**Problem**
- Build an agent decision system that is transparent, debuggable, and consistent with Raven’s goal-based design.

**Approach**
**Perception**
- Vision cone via dot products
- Line-of-sight checks against wall segments
- Visibility gated by distance, FOV, and occlusion

**Sensory Memory**
- Stores last known positions
- Visibility timestamps
- Shootable state
- Memory decay over a fixed time horizon

**Decision Making**
GoalThink evaluates competing goals:
- Explore
- Attack
- Get weapon
- Get health
Goals are composable (GoalComposite) and stack-based
Arbitration runs on regulated intervals
Goals implement a fuzzy logic system

**Movement**
- Steering behaviors layered on top of navigation
- Weighted blending allows smooth transitions between goals

**Key Decisions**
- Use regulators to bound update rates (e.g., vision updates every ~4s, target selection every ~2s).
- Keep goals composable via `GoalComposite` and explicit subgoal stacks for traceable behavior.

**Tradeoffs**
- Regulated updates introduce small reaction latency
- Single-threaded AI caps extreme agent counts
- Goal arbitration scales linearly with evaluator count

**Complexity/Performance**
- Perception scales with nearby agents and wall checks; bucketed walls keep projectile checks localized.
- Goal evaluation is O(G) per arbitration, with G evaluators and small subgoal stacks.

## References
- Marcin Jamro, *C# Data Structures and Algorithms - Second Edition* — adjacency list design, heap-based shortest path methods.
- Wendy Stahler, *Beginning Math and Physics for Game Programmers* — line intersection and circle collision math foundations.
- Mat Buckland, *Programming Game AI by Example* — goal-based architecture and overall Raven inspiration.
