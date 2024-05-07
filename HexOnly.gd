extends LineEdit

signal tint_changed(color : Color)

func _ready() -> void:
	text_changed.connect(_on_text_changed)
	text_submitted.connect(_on_text_submitted)

func _on_text_changed(new_text : String) -> void:
	var caret_pos = caret_column
	var t = new_text.to_upper().replace(" ", "")
	var out : String = ""
	for i in t.length():
		var c : String = t.substr(i, 1)
		match c:
			"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F":
				out += c
	out = out.left(6)
	text = out
	caret_column = caret_pos

func _on_text_submitted(new_text : String) -> void:
	var c : Color = Color("#%s" % text)
	tint_changed.emit(c)
	release_focus()
