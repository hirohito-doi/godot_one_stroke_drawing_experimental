extends CanvasLayer

signal level_up


func show_message(is_complete:bool) -> void:
	$NextLevelButton.visible = !is_complete
	$EndLabel.visible = is_complete
	visible = true


func _on_next_level_button_pressed() -> void:
	level_up.emit()
