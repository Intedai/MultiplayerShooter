extends Node

# Will turn false again after the main menu raises the error
var raise_error_on_main_menu = false
var error_on_start: String

func raise_main_menu_error(error_msg: String) -> void:
	error_on_start = error_msg
	raise_error_on_main_menu = true
	get_tree().change_scene_to_file("res://MainScenes/MainMenu/main_menu.tscn")
