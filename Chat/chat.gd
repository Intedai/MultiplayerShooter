extends Control

@onready var line_edit: LineEdit = $MarginContainer/HBoxContainer/VBoxContainer/LineEdit

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("chat") and !line_edit.has_focus():
		visible = not visible
		await get_tree().process_frame
		line_edit.grab_focus()
		
		return
	
	if event.is_action_pressed("send_chat_msg") and line_edit.has_focus():
		line_edit.release_focus()
		visible = not visible
		
		# TODO: Add send message logic
		print(str(multiplayer.get_unique_id()) + ": " + line_edit.text)
		line_edit.clear()
