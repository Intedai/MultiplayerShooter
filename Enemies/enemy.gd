extends CharacterBody2D
class_name Enemy

@export var health: int

@rpc("any_peer", "call_local", "reliable")
func take_damage(damage: int):
	health -= damage
	if health <= 0:
		on_death()

func on_death():
	# TODO: Add Despawn animation
	queue_free()
