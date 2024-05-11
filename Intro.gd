extends Node2D

@onready var UpgradeTokensNode = $HBoxContainer2/Label

const credits = [
	["Design", "Majenko"],
	["Programming", "Majenko"],
	["Music", "Jeremy Blake"],
	["Sound Effects", "Majenko"]
]

var credit : int = 0

func _ready() -> void:
	#	dump_all("res://")
	
		UpgradeTokensNode.text = "%d" % Global.upgrade_tokens
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		EventBus.update_score.connect(_on_update_score)
		EventBus.update_highscore.connect(_on_update_highscore)
		_on_update_score(Global.score)
		_on_update_highscore(Global.highscore)
		$VBoxContainer/Play/VBoxContainer/Play.grab_focus()
		Music.play_intro()
		get_tree().create_timer(5).timeout.connect(_show_credits)

func _show_credits() -> void:
	$HBoxContainer/Credits/CreditsRole.modulate = Color(0, 0, 0, 0)
	$HBoxContainer/Credits/CreditsPerson.modulate = Color(0, 0, 0, 0)
	$HBoxContainer/Credits/CreditsRole.text = credits[credit][0]
	$HBoxContainer/Credits/CreditsPerson.text = credits[credit][1]
	var tween = get_tree().create_tween()
	tween.tween_property($HBoxContainer/Credits/CreditsRole, "modulate", Color(1, 1, 1, 1), 1)
	tween.tween_property($HBoxContainer/Credits/CreditsPerson, "modulate", Color(1, 1, 1, 1), 1)
	tween.finished.connect(_show_credits_done)

func _show_credits_done() -> void:
	credit += 1
	if credit >= credits.size():
		credit = 0
	get_tree().create_timer(5).timeout.connect(_hide_credits)

func _hide_credits() -> void:
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property($HBoxContainer/Credits/CreditsRole, "modulate", Color(0, 0, 0, 0), 1)
	tween.tween_property($HBoxContainer/Credits/CreditsPerson, "modulate", Color(0, 0, 0, 0), 1)
	tween.finished.connect(_hide_credits_done)

func _hide_credits_done() -> void:
	get_tree().create_timer(1).timeout.connect(_show_credits)

func _on_button_pressed() -> void:
	Global.start_level = "DUNKANOID"
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
		


func _on_play_level_pressed() -> void:
	$LoadPanel.show_panel(true)

func _on_load_panel_load_level(level_name: String) -> void:
	Global.start_level = level_name
	get_tree().change_scene_to_file("res://Dunkanoid.tscn")


func _on_upgrades_pressed() -> void:
	get_tree().change_scene_to_file("res://Upgrades.tscn")
