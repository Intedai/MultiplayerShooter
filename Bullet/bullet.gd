extends Area2D

const SPEED = 100

# Called when the node enters the scene tree for the first time.
func _physics_process(delta: float) -> void:
	position.y -= SPEED * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
