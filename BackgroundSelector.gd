extends OptionButton

func _ready() -> void:
	update_background_list()

func update_background_list() -> void:
	clear()
	var i : int = 0
	var keys = Global.Backgrounds.keys()
	keys.sort()
	for bg in keys:
		add_item(bg)

func select_by_name(name : String) -> void:
	for i in item_count:
		if get_item_text(i) == name:
			selected = i

func get_selected_text() -> String:
	return get_item_text(selected)
