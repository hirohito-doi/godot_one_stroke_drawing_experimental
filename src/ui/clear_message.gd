extends CanvasLayer

signal level_up



func _on_next_level_button_pressed() -> void:
	level_up.emit()
