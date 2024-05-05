extends Node2D

var paused : bool = false

func _process(_delta : float) -> void:
	if Input.is_action_just_pressed("pause"):
		if paused:
			visible = false
			paused = false
			get_tree().paused = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
		else:
			visible = true
			paused = true
			get_tree().paused = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if Input.is_action_just_pressed("mute"):
		AudioServer.set_bus_mute(0, !AudioServer.is_bus_mute(0))
