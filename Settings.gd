extends Node2D

func _ready() -> void:
	$VBoxContainer/HBoxContainer/LeftPanel/Relative.button_pressed = Global.relative_mouse
	$VBoxContainer/HBoxContainer/LeftPanel/Absolute.button_pressed = !Global.relative_mouse
	$VBoxContainer/HBoxContainer/RightPanel/Volume.set_value_no_signal(Global.volume)

func _on_relative_pressed() -> void:
	Global.relative_mouse = true

func _on_absolute_pressed() -> void:
	Global.relative_mouse = false

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://Intro.tscn")

func _on_volume_drag_ended(value_changed: bool) -> void:
	Global.volume = $VBoxContainer/HBoxContainer/RightPanel/Volume.value
	$Boink.play()
