extends Node

const PLAYER = preload("res://Player/player.tscn")

@onready var player_spawner: MultiplayerSpawner = $PlayerSpawner
@onready var spawn_point: Marker2D = $SpawnPoint
@onready var multiplayer_ui: Control = $UI/Multiplayer

var peer = ENetMultiplayerPeer.new()

func _ready() -> void:
	player_spawner.spawn_function = spawn_player

func _on_host_pressed() -> void:
	peer.create_server(10101)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(
		func(pid):
			print(str(pid) + " joined!")
			player_spawner.spawn(pid)
	)
	multiplayer_ui.hide()
	player_spawner.spawn(1)

func _on_join_pressed() -> void:
	peer.create_client("localhost", 10101)
	multiplayer.multiplayer_peer = peer
	multiplayer_ui.hide()

func spawn_player(pid):
	var player: Player = PLAYER.instantiate()
	player.name = str(pid)
	player.global_position = spawn_point.global_position

	return player
