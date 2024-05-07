extends Node2D

func _ready() -> void:
	EventBus.update_score.connect(_on_update_score)
	_on_update_score(Global.score)
	Music.play_intro()
	Music.jingle(Music.JINGLE_GAME_OVER)

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Intro.tscn")

func _on_update_score(score : int) -> void:
	$VBoxContainer/ScoreBox.text = "%08d" % score


func _on_game_over_sound_finished() -> void:
	get_tree().change_scene_to_file("res://Intro.tscn")
