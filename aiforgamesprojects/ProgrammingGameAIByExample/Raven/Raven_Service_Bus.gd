class_name RavenEventBus
extends Node

enum System {BRAIN}



var selected_node: RavenNode = null

signal mode_changed(mode: MapDrawing.tool_state)
signal weapon_popup()
signal submitted_weapon(weapon: RavenNodeItemWeapon.WeaponSubtype)

signal fire_projectile(bullet: RavenProjectile)


signal agent_goal_changed(agent: RavenAgent, goal: GoalEvaluator.GoalType)



# Map signals
signal game_start_requested()


# agent selections
signal agent_selected(agent: RavenAgent)
signal agent_delesected()


# debugging system
signal debug_event(system: System  ,json_dict: Dictionary)
