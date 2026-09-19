extends Control

@onready var main_menu_buttons: VBoxContainer = $MainMenuButtons
@onready var host_server_menu: VBoxContainer = $HostServerMenu
@onready var join_server_menu: VBoxContainer = $JoinServerMenu
@onready var connection_screen: VBoxContainer = $ConnectionScreen
@onready var error_screen: VBoxContainer = $ErrorScreen

@onready var host_port_input: LineEdit = $HostServerMenu/HBoxContainer/PortInput

# Addr
@onready var address_input: LineEdit = $JoinServerMenu/AddrContrainer/AddressInput
@onready var join_port_input: LineEdit = $JoinServerMenu/AddrContrainer/PortInput

@onready var error_label: Label = $ErrorScreen/Error

# Whenever ErrorManager raises an error on start the go back will be main_menu_buttons
@onready var go_back_node: Control = main_menu_buttons

func _ready() -> void:
	# Client failed to connect to server
	multiplayer.connection_failed.connect(_on_connection_failed)
	
	# Client connected successfully to server
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	
	if ErrorManager.raise_error_on_main_menu:
		raise_error(ErrorManager.error_on_start)
		ErrorManager.raise_error_on_main_menu = false

func _on_connection_failed():
	go_back_node = join_server_menu
	raise_error("Failed to connect to server")

func _on_connected_to_server():
	get_tree().change_scene_to_file("res://MainScenes/Game/game.tscn")

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
	var err: Error = peer.create_server(int(host_port_input.text))
	if err:
		go_back_node = host_server_menu
		raise_error(str(err))
		return

	multiplayer.multiplayer_peer = peer
	
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

	var err: Error = peer.create_client(address_input.text, int(join_port_input.text))

	if err:
		go_back_node = join_server_menu
		raise_error(str(err))
		return

	multiplayer.multiplayer_peer = peer

# Error screen
func raise_error(err: String) -> void:
	main_menu_buttons.visible = false
	host_server_menu.visible = false
	join_server_menu.visible = false
	connection_screen.visible = false
	
	error_label.text = err
	
	error_screen.visible = true

func _on_go_back_pressed() -> void:
	error_screen.visible = false
	go_back_node.visible = true
