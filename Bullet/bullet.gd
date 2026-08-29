extends Area2D

@export var speed: int
@export var damage: int

# Called when the node enters the scene tree for the first time.
func _physics_process(delta: float) -> void:
	position.y -= speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if !is_multiplayer_authority() or body is not Enemy:
		return
	var enemy = body as Enemy
	
	enemy.take_damage.rpc_id(1, damage)
	destroy.rpc()

@rpc("call_local")
func destroy():
	queue_free()
