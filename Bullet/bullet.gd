extends Area2D
class_name Bullet

@export var speed: int
@export var damage: int

var shooter: Player
var destroyed = false

# Called when the node enters the scene tree for the first time.
func _physics_process(delta: float) -> void:
	position.y -= speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	destroy()

func _on_area_entered(area: Area2D) -> void:
	# "destroyed" exists to avoid race condition
	if destroyed or !is_multiplayer_authority() or area is not Enemy:
		return

	EffectManager.spawn_effect.rpc("bullet_hit", global_position)

	var enemy = area as Enemy	
	enemy.take_damage.rpc_id(1, damage, shooter)
	
	destroy.rpc()

@rpc("call_local")
func destroy() -> void:
	destroyed = true
	queue_free()
