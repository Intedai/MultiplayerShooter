extends Area2D
class_name Enemy

signal died(enemy: Enemy)

@export var health: int
@export var score: int
@export var speed: int
@export var explosion_scene: PackedScene

func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority():
		return
	position.y += speed * delta
		
@rpc("any_peer", "call_local", "reliable")
func take_damage(damage: int, shooter: Player) -> void:
	health -= damage
	if health <= 0:
		on_death(shooter)

func on_death(shooter: Player) -> void:
	shooter.add_score.rpc(score)
	died.emit(self)

	EffectManager.spawn_effect.rpc("explosion", global_position)

	destroy()

func destroy():
	if !is_multiplayer_authority():
		return
	queue_free()
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	destroy()
