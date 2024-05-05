extends OptionButton

func _ready() -> void:
	update_level_list()

func update_level_list() -> void:
	clear()
	var already : Array[String] = []
	for file in DirAccess.get_files_at("res://Levels"):
		if file.ends_with(".json"):
			if already.has(file):
				continue
			already.push_back(file)
			var data = JSON.parse_string(FileAccess.get_file_as_string("res://Levels/%s" % file))
			add_item(data.name)
			set_item_metadata(item_count - 1, "res://Levels/%s" % file)
	for file in DirAccess.get_files_at("user://Levels"):
		if file.ends_with(".json"):
			if already.has(file):
				continue
			already.push_back(file)
			var data = JSON.parse_string(FileAccess.get_file_as_string("user://Levels/%s" % file))
			add_item(data.name)
			set_item_metadata(item_count - 1, "user://Levels/%s" % file)

func select_by_name(name : String) -> void:
	for i in item_count:
		if get_item_text(i) == name:
			selected = i

func get_selected_text() -> String:
	return get_item_text(selected)
