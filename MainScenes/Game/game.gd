extends Node

const PLAYER = preload("res://Player/player.tscn")

@onready var player_spawner: MultiplayerSpawner = $PlayerSpawner
@onready var spawn_point: Marker2D = $SpawnPoint
@onready var total_score_label: Label = $UI/MarginContainer/TotalScore
@onready var chat: Chat = $UI/MarginContainer/Chat

var total_score = 0

func _ready() -> void:
	player_spawner.spawn_function = spawn_player
	
	if multiplayer.is_server():
		player_spawner.spawn(1)

		multiplayer.peer_connected.connect(_on_peer_connected)
		multiplayer.peer_disconnected.connect(_on_peer_disconnected)

func _on_peer_connected(pid: int) -> void:
	chat.add_msg.rpc(str(pid) + " joined the game!", false)
	player_spawner.spawn(pid)

func _on_peer_disconnected(pid: int) -> void:
	chat.add_msg.rpc(str(pid) + " left the game!", false)
	# TODO: Remove player

@rpc("call_local", "reliable")
func update_total_score(new_value: int) -> void:
	total_score += new_value
	total_score_label.text = "Total Score: " + str(total_score)

func spawn_player(pid) -> Player:
	var player: Player = PLAYER.instantiate()
	player.name = str(pid)
	player.global_position = spawn_point.global_position

	return player
