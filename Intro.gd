extends Node2D

func _ready() -> void:
	#	dump_all("res://")
	
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		EventBus.update_score.connect(_on_update_score)
		EventBus.update_highscore.connect(_on_update_highscore)
		_on_update_score(Global.score)
		_on_update_highscore(Global.highscore)
		$VBoxContainer/HBoxContainer/Play.grab_focus()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Dunkanoid.tscn")
	

func _on_update_score(score : int) -> void:
	$HBoxContainer/Score/ScoreBox.text = "%08d" % score

func _on_update_highscore(score : int) -> void:
	$HBoxContainer/HighScore/HighScoreBox.text = "%08d" % score


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://Settings.tscn")

func _on_editor_pressed() -> void:
	get_tree().change_scene_to_file("res://LevelEditor.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()

func dump_all(dir : String, indent : String = "") -> void:
	for file in DirAccess.get_directories_at(dir):
		print("%s%s" % [indent, file])
		dump_all("%s/%s" % [dir, file], "%s  " % indent)
		
	for file in DirAccess.get_files_at(dir):
		print("%s%s" % [indent, file])
		
