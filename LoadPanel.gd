extends PanelContainer

signal load_file(filename : String)
signal load_level(level_name : String)

func update_level_list(unique : bool = false) -> void:

	var list : Array[String] = []

	var vb = $VBoxContainer/ScrollContainer/VBoxContainer
	
	for k in vb.get_children():
		vb.remove_child(k)
		k.queue_free()

	for file in DirAccess.get_files_at("user://Levels"):
		if file.ends_with(".json"):
			var data = JSON.parse_string(FileAccess.get_file_as_string("user://Levels/%s" % file))
			var b = Button.new()
			b.theme = load("res://MainTheme.tres")
			b.text = data.name
			b.theme_type_variation = "UserFile"
			b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			b.pressed.connect(_on_load_file_pressed.bind(b))
			b.set_meta("filename", "user://Levels/%s" % file)
			b.set_meta("level_name", data.name)
			b.icon = load("res://Icons/User.png")
			vb.add_child(b)
			list.push_back(data.name)
	for file in DirAccess.get_files_at("res://Levels"):
		if file.ends_with(".json"):
			var data = JSON.parse_string(FileAccess.get_file_as_string("res://Levels/%s" % file))
			if unique:
				if list.has(data.name):
					continue
			var b = Button.new()
			b.theme = load("res://MainTheme.tres")
			b.theme_type_variation = "InternalFile"
			b.text = data.name
			b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			b.pressed.connect(_on_load_file_pressed.bind(b))
			b.set_meta("filename", "res://Levels/%s" % file)
			b.set_meta("level_name", data.name)
			b.icon = load("res://Icons/Internal.png")
			vb.add_child(b)

func show_panel(unique : bool = false) -> void:
	update_level_list(unique)
	visible = true

func _on_cancel_pressed() -> void:
	visible = false

func _on_load_file_pressed(node):
	load_file.emit(node.get_meta("filename"))
	load_level.emit(node.get_meta("level_name"))
	visible = false
