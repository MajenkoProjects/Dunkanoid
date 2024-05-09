extends LineEdit

func _ready() -> void:
	text_changed.connect(_on_text_changed)
	text_submitted.connect(_on_text_submitted)

func _on_text_changed(new_text : String) -> void:
	var caret_pos = caret_column
	text = new_text.to_upper()
	caret_column = caret_pos

func _on_text_submitted(new_text : String) -> void:
	release_focus()
