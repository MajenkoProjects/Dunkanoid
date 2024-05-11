extends Node2D

@onready var Tokens = $VBoxContainer/Tokens/Label
@onready var Description = $VBoxContainer/Description

func _ready() -> void:
	EventBus.upgrade_tokens_updated.connect(_on_upgrade_tokens_updated)
	Tokens.text = "%d" % Global.upgrade_tokens
	
func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://Intro.tscn")

func _on_upgrade_tokens_updated(qty : int) -> void:
	Tokens.text = "%d" % qty


func _show_description(description: String) -> void:
	Description.text = description

func _hide_description() -> void:
	Description.text = ""
