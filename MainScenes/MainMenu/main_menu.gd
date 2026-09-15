extends Control

@onready var main_menu_buttons: VBoxContainer = $MainMenuButtons
@onready var host_server_menu: VBoxContainer = $HostServerMenu
@onready var join_server_menu: VBoxContainer = $JoinServerMenu
@onready var connection_screen: VBoxContainer = $ConnectionScreen

@onready var host_port_input: LineEdit = $HostServerMenu/HBoxContainer/PortInput

# Addr
@onready var address_input: LineEdit = $JoinServerMenu/AddrContrainer/AddressInput
@onready var join_port_input: LineEdit = $JoinServerMenu/AddrContrainer/PortInput

func _ready() -> void:
	# Client failed to connect to server
	multiplayer.connection_failed.connect(func(): print("failed to connect"))
	
	# Client connected successfully to server
	multiplayer.connected_to_server.connect(
		func():
			get_tree().change_scene_to_file("res://MainScenes/Game/game.tscn")
	)

# Main menu btns
func _on_host_pressed() -> void:
	main_menu_buttons.visible = false
	host_server_menu.visible = true

func _on_join_pressed() -> void:
	main_menu_buttons.visible = false
	join_server_menu.visible = true

func _on_quit_pressed() -> void:
	get_tree().quit()

# Host server menu
func _on_host_cancel_pressed() -> void:
	host_port_input.clear()
	host_server_menu.visible = false
	main_menu_buttons.visible = true

func _on_start_pressed() -> void:
	print("Starting server in port: " + str(int(host_port_input.text)))
	
	var peer = ENetMultiplayerPeer.new()
	var err = peer.create_server(int(host_port_input.text))
	
	if err:
		print(err)
		return

	multiplayer.multiplayer_peer = peer
	
	host_port_input.clear()
	
	get_tree().change_scene_to_file("res://MainScenes/Game/game.tscn")

# Join server menu
func clear_inputs():
	address_input.clear()
	join_port_input.clear()

func _on_join_cancel_pressed() -> void:
	clear_inputs()
	join_server_menu.visible = false
	main_menu_buttons.visible = true

func _on_connect_pressed() -> void:
	print("connecting to " + address_input.text + ":" + join_port_input.text)

	join_server_menu.visible = false
	connection_screen.visible = true
	
	var peer = ENetMultiplayerPeer.new()

	print("port:" + str(int(join_port_input.text)))
	var err = peer.create_client(address_input.text, int(join_port_input.text))

	if err:
		print(err)
		return

	multiplayer.multiplayer_peer = peer

	clear_inputs()
