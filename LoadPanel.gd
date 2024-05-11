extends PanelContainer

signal load_file(filename : String)
signal load_level(level_name : String)

var MainTheme = preload("res://MainTheme.tres")

func update_level_list(unique : bool = false) -> void:

	var list : Array[String] = []

	var vb = $VBoxContainer/ScrollContainer/VBoxContainer
	
	for k in vb.get_children():
		vb.remove_child(k)
		k.queue_free()
	
	if DirAccess.dir_exists_absolute("user://Levels"):
		var lb = Label.new();
		lb.theme = MainTheme
		lb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		lb.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		lb.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lb.text = "User Levels"
		vb.add_child(lb)

	for file in DirAccess.get_files_at("user://Levels"):
		if file.ends_with(".json"):
			var data = JSON.parse_string(FileAccess.get_file_as_string("user://Levels/%s" % file))
			var b = Button.new()
			b.theme = MainTheme
			b.text = data.name
			b.theme_type_variation = "UserFile"
			b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			b.pressed.connect(_on_load_file_pressed.bind(b))
			b.set_meta("filename", "user://Levels/%s" % file)
			b.set_meta("level_name", data.name)
			b.icon = load("res://Icons/User.png")
			vb.add_child(b)
			list.push_back(data.name)

	var l = Label.new();
	l.theme = MainTheme
	l.text = "Internal Levels"
	l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vb.add_child(l)


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
