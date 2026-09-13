extends MultiplayerSpawner

@onready var game: Node = $".."
@onready var spawn_player_button: Button = $"../UI/MarginContainer/SpawnPlayerButton"

const spawn_x_range = [-226, 226]
const spawn_y = -137

const ENEMY = preload("res://Enemies/Enemy/enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_player_button.focus_mode = Control.FOCUS_NONE # So shooting won't spawn enemies
	spawn_function = spawn_enemy

func spawn_enemy(_data) -> Enemy:
	var enemy: Enemy = ENEMY.instantiate()
	enemy.position.x = randi_range(spawn_x_range[0], spawn_x_range[1])
	enemy.position.y = spawn_y
	enemy.died.connect(on_enemy_death)
	return enemy

func on_enemy_death(enemy: Enemy) -> void:
	game.update_total_score.rpc(enemy.score)

func _on_button_pressed() -> void:
	if is_multiplayer_authority():
		print("spawning enemy")
		spawn()
	else:
		print("only the host can spawn enemies")
