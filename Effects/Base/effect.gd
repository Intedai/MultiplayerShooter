extends AnimatedSprite2D
class_name Effect

func _ready() -> void:
	connect("animation_finished", _on_animation_finished)

func _on_animation_finished() -> void:
	queue_free()
