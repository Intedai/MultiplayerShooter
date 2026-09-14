extends Node

const PLAYER = preload("res://Player/player.tscn")

@onready var player_spawner: MultiplayerSpawner = $PlayerSpawner
@onready var spawn_point: Marker2D = $SpawnPoint
@onready var multiplayer_ui: Control = $UI/MarginContainer/Multiplayer
@onready var total_score_label: Label = $UI/MarginContainer/TotalScore
@onready var chat: Chat = $UI/MarginContainer/Chat

var peer = ENetMultiplayerPeer.new()

var total_score = 0

func _ready() -> void:
	player_spawner.spawn_function = spawn_player

@rpc("call_local", "reliable")
func update_total_score(new_value: int) -> void:
	total_score += new_value
	total_score_label.text = "Total Score: " + str(total_score)

func _on_host_pressed() -> void:
	peer.create_server(10101)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(
		func(pid):
			chat.add_msg.rpc(str(pid) + " joined the game!", false)
			player_spawner.spawn(pid)
	)
	multiplayer_ui.hide()
	player_spawner.spawn(1)

func _on_join_pressed() -> void:
	peer.create_client("localhost", 10101)
	multiplayer.multiplayer_peer = peer
	multiplayer_ui.hide()

func spawn_player(pid) -> Player:
	var player: Player = PLAYER.instantiate()
	player.name = str(pid)
	player.global_position = spawn_point.global_position

	return player
