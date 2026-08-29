extends MultiplayerSpawner

const ENEMY = preload("res://Enemies/Enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Button.focus_mode = Control.FOCUS_NONE # So shooting won't spawn enemies
	spawn_function = spawn_enemy

func spawn_enemy(_data) -> Enemy:
	var enemy: Enemy = ENEMY.instantiate()
	return enemy

func _on_button_pressed() -> void:
	if is_multiplayer_authority():
		print("spawning enemy")
		spawn()
	else:
		print("only the host can spawn enemies")
