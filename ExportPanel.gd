extends PanelContainer

func _ready() -> void:
	pass

func show_panel(ob : Dictionary) -> void:
	var text = JSON.stringify(ob, "  ")
	var b64 = Marshalls.utf8_to_base64(text)
	$VBoxContainer/ExportedCode.text = b64
	visible = true
	$VBoxContainer/ExportedCode.select_all()
	$VBoxContainer/ExportedCode.copy()

func _on_close_pressed() -> void:
	visible = false
