extends Node2D

func _ready() -> void:
	EventBus.update_score.connect(_on_update_score)
	_on_update_score(Global.score)
	Music.play_game_over()
	var tween = get_tree().create_tween()
	tween.tween_property($ColorRect, "color", Color(0, 0, 0, 0), 2)

func _process(_delta : float) -> void:
	if Input.is_action_just_pressed("fire"):
		var tween = get_tree().create_tween()
		tween.tween_property($ColorRect, "color", Color(0, 0, 0, 1), 3)
		tween.finished.connect(_wait_load_intro)
		
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			var tween = get_tree().create_tween()
			tween.tween_property($ColorRect, "color", Color(0, 0, 0, 1), 3)
			tween.finished.connect(_wait_load_intro)

func _on_update_score(score : int) -> void:
	$VBoxContainer/HBoxContainer/ScoreBox.text = "%08d" % score


func _on_sub_viewport_container_scroll_finished() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($ColorRect, "color", Color(0, 0, 0, 1), 3)
	tween.finished.connect(_wait_load_intro)

func _wait_load_intro() -> void:
	Music.fade_down(3)
	get_tree().create_timer(3).timeout.connect(_load_intro)

func _load_intro() -> void:
	get_tree().change_scene_to_file("res://Intro.tscn")
