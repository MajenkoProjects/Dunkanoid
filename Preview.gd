extends Node2D

func _ready() -> void:
	get_tree().create_timer(5).timeout.connect(_show_level)

func _show_level() -> void:
	var level = get_random_level()
	$Label.text = format_time(Global.get_best_time(level))
	$SubViewportContainer/Level.load_level(level)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 1)
	tween.finished.connect(_wait_showing)

func _wait_showing() -> void:
	get_tree().create_timer(5).timeout.connect(_hide_level)

func _hide_level() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 1)
	tween.finished.connect(_wait_hiding)		

func _wait_hiding() -> void:
	get_tree().create_timer(5).timeout.connect(_show_level)
	
	
func get_random_level() -> String:
	var levels : Array[String] = []
	if DirAccess.dir_exists_absolute("user://Levels"):
		for file in DirAccess.get_files_at("user://Levels"):
			if file.ends_with(".json"):
				var data = JSON.parse_string(FileAccess.get_file_as_string("user://Levels/%s" % file))
				if data != null:
					levels.push_back(data.get("name"))
	for file in DirAccess.get_files_at("res://Levels"):
		if file.ends_with(".json"):
			var data = JSON.parse_string(FileAccess.get_file_as_string("res://Levels/%s" % file))
			if data != null:
				if not levels.has(data.get("name")):
					levels.push_back(data.get("name"))
	levels.erase("NOTFOUND")
	return levels.pick_random()

func format_time(time : int) -> String:
	if time > 3600000:
		return "--:--.--"
	return "%02d:%05.2f" % [int(time / 60000.0), time % 60000 / 1000.0]
