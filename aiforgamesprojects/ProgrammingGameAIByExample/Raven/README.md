# Raven — AI Implementation

## Project Summary
Raven is a recreation of the Raven project from *Programming Game AI by Example* Written in GDScript - a Python like programming language.
Primary constraints are real-time simulation, deterministic behavior, and maintainable data structures for experimentation.

## General Overview:
- Custom map editor using JSON serialisation / parsing using multi-threading jobs
- Collision system using spatial buckets and line/segment intersection
- Custom navigation system
- Custom AI Agent system including: Perception of environment, State memory, decision making through goal arbitration

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
- Support consistent navigation for agents on a grid world with obstacles, items, and spawn points.

**Approach**
- Custom graph structure (`RavenGraph`) stores nodes as an array of `RavenNode` and edges in a dictionary keyed by node id.
- Nodes are grid-aligned (row/column) with explicit types (traversal, wall, spawn, item). Edges are `NavGraphEdge` entries between neighbor nodes.
- Pathfinding is performed with Dijkstra (targeted and all-pairs precompute) and A* with a Euclidean heuristic.
- Design references *C# Data Structures and Algorithms - Second Edition* by Marcin Jamro for adjacency list patterns and heap-based shortest path implementations.

**Key Decisions**
- Use adjacency lists (dictionary of arrays) for predictable memory access in a dense grid.
- Store node ids as contiguous indices for cache-friendly traversal and easier precomputation.
- Precompute all-pairs costs per node in a background thread to accelerate runtime queries.

**Tradeoffs**
- Precomputing `pre_calc_costs` trades memory for faster path cost lookups.

### Collision System
**Problem**
- Provide deterministic, real-time collision checks for walls and projectiles with predictable performance.

**Approach**
- Wall geometry is derived from grid nodes: each wall cell computes segment edges and normals.
- Broad-phase uses spatial buckets (`cell_buckets_static`) keyed by grid cells to limit collision checks.
- Narrow-phase uses line/segment intersection for line-of-sight occlusion and circle-circle tests for agents/projectiles.
- Developed with reference to *Beginning Math and Physics for Game Programmers* by Wendy Stahler, especially for line intersection and circle intersection math.

**Key Decisions**
- Favor deterministic, CPU-only math primitives (no physics engine dependency) for reproducibility.
- Use bucketed lookups for projectiles and local movement checks to maintain real-time constraints.

**Tradeoffs**
- Grid-aligned walls simplify collision math but limit fine-grained geometry detail.
- Some line-of-sight checks still iterate all buckets, which is acceptable for current map sizes but not optimal at scale.


### Map Editor
**Problem**
- Author and iterate on Raven maps without external tooling, while keeping data aligned to the navigation and collision systems.

**Approach**
- Custom UI tools (toggleable wall/spawn/weapon placement) operate on the same grid used by navigation.
- Maps serialize to JSON in `Maps/` with rows/columns, resolution, cell size, world size, nodes, and precomputed costs.
- Loading reconstructs the grid, graph nodes, items, and spatial buckets to keep nav + collision in sync.

**Key Decisions**
- Grid-based authoring ensures consistency across navigation and collision systems.
- Embed `pre_calc_costs` in map files to remove runtime spikes for heavy path queries.

**Tradeoffs**
- JSON maps are human-readable but larger; binary would be faster to load at scale.
- Grid resolution is a fixed tradeoff between path precision and node count.

**Complexity/Performance**
- Load time scales with node count and the size of precomputed cost tables.
- Save step runs Dijkstra for all traversal nodes; work is split across multiple threads.

### AI Agent System
**Problem**
- Build an agent decision system that is transparent, debuggable, and consistent with Raven’s goal-based design.

**Approach**
- Perception uses a vision polygon, line-of-sight checks against wall segments, and FOV tests via dot products.
- Sensory memory stores last-sensed position, visibility timestamps, and shootable state with a fixed memory span.
- Goal arbitration is handled by `GoalThink` evaluators (explore, attack, get weapon, get health) inspired by *Programming Game AI by Example*.
- Decision loop runs on a regulated cadence to decouple sensory updates, goal arbitration, and weapon selection.

**Key Decisions**
- Use regulators to bound update rates (e.g., vision updates every ~4s, target selection every ~2s).
- Keep goals composable via `GoalComposite` and explicit subgoal stacks for traceable behavior.

**Tradeoffs**
- Regulated updates reduce CPU cost but can introduce slight reaction latency.
- Goal arbitration is single-threaded to keep behavior deterministic and debuggable.

**Complexity/Performance**
- Perception scales with nearby agents and wall checks; bucketed walls keep projectile checks localized.
- Goal evaluation is O(G) per arbitration, with G evaluators and small subgoal stacks.

## References
- Marcin Jamro, *C# Data Structures and Algorithms - Second Edition* — adjacency list design, heap-based shortest path methods.
- Wendy Stahler, *Beginning Math and Physics for Game Programmers* — line intersection and circle collision math foundations.
- Mat Buckland, *Programming Game AI by Example* — goal-based architecture and overall Raven inspiration.
