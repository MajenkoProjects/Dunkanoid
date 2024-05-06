extends PanelContainer

signal object_imported(data : Dictionary)

func show_panel() -> void:
	$VBoxContainer/ImportedCode.text = ""
	$VBoxContainer/ImportedCode.grab_focus()
	visible = true

func _on_import_pressed() -> void:
	var text = Marshalls.base64_to_utf8($VBoxContainer/ImportedCode.text)
	var ob = JSON.parse_string(text)
	if ob != null:
		object_imported.emit(ob)
		visible = false

func _on_cancel_pressed() -> void:
	visible = false
