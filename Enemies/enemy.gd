extends CharacterBody2D
class_name Enemy

signal died(enemy: Enemy)

@export var health: int
@export var score: int
@export var speed: int

@rpc("any_peer", "call_local", "reliable")
func take_damage(damage: int, shooter: Player) -> void:
	health -= damage
	if health <= 0:
		on_death(shooter)

func on_death(shooter: Player) -> void:
	# TODO: Add Despawn animation
	shooter.add_score.rpc(score)
	died.emit(self)
	queue_free()
