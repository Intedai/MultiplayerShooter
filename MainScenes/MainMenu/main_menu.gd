extends Control

@onready var main_menu_buttons: VBoxContainer = $MainMenuButtons
@onready var join_server_menu: VBoxContainer = $JoinServerMenu
@onready var connection_screen: VBoxContainer = $ConnectionScreen

# Addr
@onready var address_input: LineEdit = $JoinServerMenu/AddrContrainer/AddressInput
@onready var port_input: LineEdit = $JoinServerMenu/AddrContrainer/PortInput

var peer = ENetMultiplayerPeer.new()

# Main menu btns
func _on_host_pressed() -> void:
	print("host pressed")

func _on_join_pressed() -> void:
	main_menu_buttons.visible = false
	join_server_menu.visible = true

func _on_quit_pressed() -> void:
	get_tree().quit()

# Join server menu
func clear_inputs():
	address_input.clear()
	port_input.clear()

func _on_cancel_pressed() -> void:
	clear_inputs()
	join_server_menu.visible = false
	main_menu_buttons.visible = true

func _on_connect_pressed() -> void:
	print("connecting to " + address_input.text + ":" + port_input.text)
	clear_inputs()
	join_server_menu.visible = false
	connection_screen.visible = true
