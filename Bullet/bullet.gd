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

func _on_body_entered(body: Node2D) -> void:
	if !is_multiplayer_authority() or body is not Enemy:
		return
	var enemy = body as Enemy
	
	enemy.take_damage.rpc_id(1, damage, shooter)
	
	# Avoid race condition
	if not destroyed:
		destroy.rpc()

@rpc("call_local")
func destroy() -> void:
	destroyed = true
	queue_free()
