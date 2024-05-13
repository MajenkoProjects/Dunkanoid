extends Node2D

@onready var ToggleNode = $VBoxContainer/HBoxContainer/LeftPanel/HBoxContainer/Toggle
@onready var RelativeNode = $VBoxContainer/HBoxContainer/LeftPanel/HBoxContainer/Relative
@onready var AbsoluteNode = $VBoxContainer/HBoxContainer/LeftPanel/HBoxContainer/Absolute
@onready var MusicNode = $VBoxContainer/HBoxContainer/RightPanel/Music
@onready var EffectsNode = $VBoxContainer/HBoxContainer/RightPanel/Effects
@onready var VersionNode = $VBoxContainer/Version

func _ready() -> void:
	VersionNode.text = "Version %s" % ProjectSettings.get_setting("application/config/version")
	ToggleNode.button_pressed = Global.relative_mouse
	AbsoluteNode.theme_type_variation = "" if Global.relative_mouse else "GlowLabel"
	RelativeNode.theme_type_variation = "GlowLabel" if Global.relative_mouse else ""
	MusicNode.set_value_no_signal(Global.music_volume)
	EffectsNode.set_value_no_signal(Global.effects_volume)


func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://Intro.tscn")

func _on_music_volume_drag_ended(value_changed: bool) -> void:
	Global.music_volume = MusicNode.value

func _on_effects_volume_drag_ended(value_changed: bool) -> void:
	Global.effects_volume = EffectsNode.value
	$Boink.play()


func _on_reset_times_pressed() -> void:
	Global.reset_best_times()
	pass # Replace with function body.


func _on_toggle_pressed() -> void:
	Global.relative_mouse = ToggleNode.button_pressed
	AbsoluteNode.theme_type_variation = "" if Global.relative_mouse else "GlowLabel"
	RelativeNode.theme_type_variation = "GlowLabel" if Global.relative_mouse else ""

func _on_absolute_pressed() -> void:
	Global.relative_mouse = false
	ToggleNode.button_pressed = false
	AbsoluteNode.theme_type_variation = "" if Global.relative_mouse else "GlowLabel"
	RelativeNode.theme_type_variation = "GlowLabel" if Global.relative_mouse else ""

func _on_relative_pressed() -> void:
	Global.relative_mouse = true
	ToggleNode.button_pressed = true
	AbsoluteNode.theme_type_variation = "" if Global.relative_mouse else "GlowLabel"
	RelativeNode.theme_type_variation = "GlowLabel" if Global.relative_mouse else ""
