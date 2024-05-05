extends OptionButton

func _ready() -> void:
	update_background_list()

func update_background_list() -> void:
	clear()
	var i : int = 0
	for file in DirAccess.get_files_at("res://Backgrounds"):
		if file.ends_with(".png"):
			add_item(file.left(-4), i)
			set_item_metadata(i, "res://Backgrounds/%s" % file)
			i += 1
	for file in DirAccess.get_files_at("user://Backgrounds"):
		if file.ends_with(".png"):
			add_item(file.left(-4), i)
			set_item_metadata(i, "user://Backgrounds/%s" % file)
			i += 1

func select_by_name(name : String) -> void:
	for i in item_count:
		if get_item_text(i) == name:
			selected = i

func get_selected_filename() -> String:
	return get_item_metadata(selected)

func get_selected_text() -> String:
	return get_item_text(selected)
