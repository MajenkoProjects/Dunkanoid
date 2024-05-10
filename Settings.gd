extends Node2D

func _ready() -> void:
	$VBoxContainer/HBoxContainer/LeftPanel/Relative.button_pressed = Global.relative_mouse
	$VBoxContainer/HBoxContainer/LeftPanel/Absolute.button_pressed = !Global.relative_mouse
	$VBoxContainer/HBoxContainer/RightPanel/Music.set_value_no_signal(Global.music_volume)
	$VBoxContainer/HBoxContainer/RightPanel/Effects.set_value_no_signal(Global.effects_volume)

func _on_relative_pressed() -> void:
	Global.relative_mouse = true

func _on_absolute_pressed() -> void:
	Global.relative_mouse = false

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://Intro.tscn")

func _on_music_volume_drag_ended(value_changed: bool) -> void:
	Global.music_volume = $VBoxContainer/HBoxContainer/RightPanel/Music.value

func _on_effects_volume_drag_ended(value_changed: bool) -> void:
	Global.effects_volume = $VBoxContainer/HBoxContainer/RightPanel/Effects.value
	$Boink.play()


func _on_reset_times_pressed() -> void:
	Global.reset_best_times()
	pass # Replace with function body.
