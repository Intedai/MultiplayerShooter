extends Control
class_name Chat

@onready var chat_text: Label = $HBoxContainer/VBoxContainer/ScrollContainer/ChatText
@onready var line_edit: LineEdit = $HBoxContainer/VBoxContainer/LineEdit
@onready var scroll_container: ScrollContainer = $HBoxContainer/VBoxContainer/ScrollContainer

signal chat_opened
signal chat_closed


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("chat") and !line_edit.has_focus():
		_toggle_input()
		await get_tree().process_frame
		line_edit.grab_focus()
		
		return
	
	if event.is_action_pressed("ui_text_submit") and line_edit.has_focus():
		line_edit.release_focus()
		_toggle_input()
		
		var msg = format_chat_msg(line_edit.text)
		
		if len(msg) != 0:
			add_msg.rpc(msg, true)
		
		line_edit.clear()

	elif event.is_action_pressed("ui_cancel") and line_edit.has_focus():
		line_edit.release_focus()
		_toggle_input()
		line_edit.clear()

@rpc("any_peer", "call_local", "reliable")
func add_msg(msg: String, sent_by_player: bool) -> void:
	if sent_by_player:
		msg = msg.insert(0, "<" + str(multiplayer.get_remote_sender_id()) + "> ")
	chat_text.text += "\n" + msg
	
func format_chat_msg(msg: String) -> String:
	# Strip whitespaces and turn multiple spaces into one
	return " ".join(msg.strip_edges().split(" ", false))

func _toggle_input() -> void:
	line_edit.visible = not line_edit.visible
	if line_edit.visible:
		scroll_container.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
		chat_opened.emit()
	else:
		scroll_container.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
		chat_closed.emit()
	scroll_to_bottom()

func scroll_to_bottom() -> void:
	for i in range(2):
		await get_tree().process_frame
	scroll_container.scroll_vertical = int(scroll_container.get_v_scroll_bar().max_value)
