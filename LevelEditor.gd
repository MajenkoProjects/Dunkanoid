extends Node2D

func _ready() -> void:
	$VBoxContainer/Left.select_by_name("NOTFOUND")
	$VBoxContainer/Right.select_by_name("NOTFOUND")
	$VBoxContainer/Background.select_by_name("BlueSlash")
	Music.pause()
	
func _on_background_item_selected(index: int) -> void:
	$Background.texture = load($VBoxContainer/Background.get_item_metadata(index))

func get_level_object() -> Dictionary:
	var data : Dictionary = {
		"name": $VBoxContainer/Name.text,
		"left": $VBoxContainer/Left.get_selected_text(),
		"right": $VBoxContainer/Right.get_selected_text(),
		"background": $VBoxContainer/Background.get_selected_text(),
		"tint": $VBoxContainer/Tint.text,
		"data": []
	}
	for row in 18:
		var s = ""
		for col in 13:
			var brick = get_node("Bricks/Row%d/Col%d" % [row, col])
			s += brick.type
		data.data.push_back(s)
	return data
	
func _on_save_pressed() -> void:
	if $VBoxContainer/Name.text == "":
		return
	var data : Dictionary = get_level_object()
	DirAccess.make_dir_recursive_absolute("user://Levels")
	var f = FileAccess.open("user://Levels/%s.json" % data.name, FileAccess.WRITE)
	f.store_string(JSON.stringify(data, "  "))
	f.close()
	
	$VBoxContainer/Left.update_level_list()
	$VBoxContainer/Right.update_level_list()
	$VBoxContainer/Left.select_by_name(data.left)
	$VBoxContainer/Right.select_by_name(data.right)
	
func _on_exit_pressed() -> void:
	Music.resume()
	get_tree().change_scene_to_file("res://Intro.tscn")



func _on_load_pressed() -> void:
	$LoadPanel.show_panel()


func _on_load_panel_load_file(filename: String) -> void:
	if FileAccess.file_exists(filename):
		var data = JSON.parse_string(FileAccess.get_file_as_string(filename))
		load_level_from_object(data)

func load_level_from_object(data : Dictionary) -> void:
	if data != null:
		$VBoxContainer/Name.text = data.get("name", "")
		$VBoxContainer/Left.select_by_name(data.get("left", "DUNKANOID"))
		$VBoxContainer/Right.select_by_name(data.get("right", "DUNKANOID"))
		$VBoxContainer/Background.select_by_name(data.get("background", "BlueSlash"))
		$Background.texture = load($VBoxContainer/Background.get_selected_filename())
		$VBoxContainer/Tint.text = data.get("tint", "FFFFFF")
		$Background.modulate = Color("#%s" % $VBoxContainer/Tint.text)
	for row in 18:
		for col in 13:
			var brick = get_node("Bricks/Row%d/Col%d" % [row, col])
			var c = data.data[row].substr(col, 1)
			brick.set_brick_type(c)


func _on_new_pressed() -> void:
	$VBoxContainer/Name.text = ""
	$VBoxContainer/Left.select_by_name("NOTFOUND")
	$VBoxContainer/Right.select_by_name("NOTFOUND")
	$VBoxContainer/Background.select_by_name("BlueSlash")
	$Background.texture = load($VBoxContainer/Background.get_selected_filename())
	$VBoxContainer/Tint.text = "FFFFFF"
	for row in 18:
		for col in 13:
			var brick = get_node("Bricks/Row%d/Col%d" % [row, col])
			brick.set_brick_type(" ")


func _on_export_pressed() -> void:
	$ExportPanel.show_panel(get_level_object())


func _on_import_pressed() -> void:
	$ImportPanel.show_panel()


func _on_import_panel_object_imported(data: Dictionary) -> void:
	load_level_from_object(data)
	pass # Replace with function body.


func _on_tint_tint_changed(color: Color) -> void:
	$Background.modulate = color
	pass # Replace with function body.
