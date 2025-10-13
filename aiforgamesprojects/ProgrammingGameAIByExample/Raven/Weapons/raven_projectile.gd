class_name RavenProjectile
extends RavenMover

var target : Vector2
var damage_inflicted : float
var heading : Vector2

var projectile_regulator = Regulator.new(6)


var owner_agent : RavenAgent
var collided := false

func _init(_target: Vector2, fired_by: RavenAgent) -> void:
	target = _target
	owner_agent = fired_by



func _out_of_world() -> bool:
	
	if position.x < 0 -20 or position.x > World.width + 20:
		return true
	
	if position.y < 0-20 or position.y > World.height +20:
		return true
	
	
	return false


func _agent_collision() -> RavenAgent:
	if !collided:
		var key = World.world_to_bucket(World.position_to_grid(position))
		var agent_bucket:Array = World.cell_buckets_agents.get(Vector2(key.x,key.y), [])
		
		#print(agent_bucket)
		
		if !agent_bucket.is_empty():
			for agent:RavenAgent in agent_bucket:
				if agent == owner_agent:
					continue
				#print("in same bucket as agent: ", agent.agent_name)
				var agent_pos: Vector2 = agent.position
				
				
				var calc:bool = (position.x-agent_pos.x)**2 + (position.y-agent.position.y)**2 <= (radius + agent.radius)**2
				if calc:
					collided = true
					print("Bullet collided: ", self)
					print("COLLIDED WITH AGENT: ", agent.agent_name)
					break
	
	return null

func _wall_collision() -> bool:
	# get bullets bucket key for position
	var key = World.world_to_bucket(World.position_to_grid(position))
	var bucket:Array = World.cell_buckets_static.get(Vector2i(int(key.x), int(key.y)), [])
	# filter buckets for only wall nodes
	bucket = bucket.filter(
		func(r:RavenNode): return r.node_type == RavenNode.NodeType.WALL
	)
	
	if bucket.is_empty():
		return false
	
	# loop over all walls in bucket and do circle-circle collision
	for node:RavenNode in bucket:
		var h2 = position.x
		var k2 = position.y
		
		var node_pos: Vector2 = World.grid_to_world(node.node_pos.x, node.node_pos.y)
		var h1 = node_pos.x
		var k1 = node_pos.y
		
		var r2 = radius
		var r1 = World.resolution/2
		
		var calc:bool = (h2-h1)**2 + (k2-k1)**2 <= (r1 + r2)**2
		
		if calc:
			return true
	return false
