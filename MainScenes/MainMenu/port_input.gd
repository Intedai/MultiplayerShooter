extends LineEdit

@onready var old_text: String = text
@onready var old_caret_column: int = caret_column

const MIN_PORT: int = 0
const MAX_PORT: int = 65535

func _ready() -> void:
	text_changed.connect(_on_text_changed)
	gui_input.connect(_on_gui_input)

func is_valid_port_str(port: String) -> bool:
	if not (port.is_valid_int() and not (port.begins_with('+') or port.begins_with('-'))):
		return false
	var int_port = int(port)
	return int_port >= MIN_PORT and int_port <= MAX_PORT

func _on_text_changed(new_text: String) -> void:
	if new_text.is_empty() or is_valid_port_str(new_text):
		old_text = new_text
		return
	text = old_text
	caret_column = old_caret_column

func _on_gui_input(_event: InputEvent) -> void:
	old_caret_column = caret_column
