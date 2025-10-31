class_name RavenEventBus
extends Node

var selected_node: RavenNode = null


signal weapon_popup()
signal submitted_weapon(weapon: RavenNodeItemWeapon.WeaponSubtype)



signal agent_goal_changed(agent: RavenAgent, goal: GoalEvaluator.GoalType)



# projectiles
signal fire_projectile(bullet: RavenProjectile)
signal projectile_sound(fired_by : RavenAgent, radius: float)


# UI Requests
signal game_start_requested()
signal dummy_agent_requested()

## Placeable popup requested from map -> UI
signal placeable_popup_requested(data: SelectableData)

## UI to map change mode
signal mode_changed(mode: MapDrawing.tool_state)

signal placeable_popup_submitted(data: SelectableData)

signal load_pop_up()


# agent selections
signal agent_selected(agent: RavenAgent)
signal agent_delesected()
signal agent_died(agent:RavenAgent)
signal agent_possess_requested()


# debugging system
signal debug_event(data: DebugData)
signal debg_mode_changed(mode:bool)

# Map drawing
signal grid_generated()
