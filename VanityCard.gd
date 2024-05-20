extends Node2D

func _ready() -> void:
	$AudioStreamPlayer.play()
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 1)
	Global.initialize()
	Music.initialize()
	Scenes.initialize()

func _on_audio_stream_player_finished() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 1)
	tween.finished.connect(_load_game)

func _load_game() -> void:
	get_tree().change_scene_to_packed(Scenes.MainMenu)
