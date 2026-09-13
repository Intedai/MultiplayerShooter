extends Node

const EXPLOSION = preload("res://Effects/Explosion/explosion.tscn")
const BULLET_HIT = preload("res://Effects/BulletHit/bullet_hit.tscn")

@rpc("call_local", "reliable")
func spawn_effect(effect_name: StringName, global_position: Vector2) -> void:
	var scene: PackedScene

	match effect_name:
		"explosion":
			scene = EXPLOSION
		"bullet_hit":
			scene = BULLET_HIT
		_:
			push_error("Effect \"" + effect_name + "\" doesn't exist!")
			return

	var node: Effect = scene.instantiate()
	node.global_position = global_position
	get_tree().current_scene.add_child(node)
