extends Node2D

var paused : bool = false

func _process(_delta : float) -> void:
	if Input.is_action_just_pressed("pause"):
		if paused:
			visible = false
			paused = false
			get_tree().paused = false
			if Global.relative_mouse:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
			$VBoxContainer/HBoxContainer/Quit.release_focus()
			EventBus.unpaused.emit()
		else:
			EventBus.paused.emit()
			visible = true
			paused = true
			get_tree().paused = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			$VBoxContainer/HBoxContainer/Quit.grab_focus()

	if Input.is_action_just_pressed("mute"):
		AudioServer.set_bus_mute(0, !AudioServer.is_bus_mute(0))

func _on_quit_pressed() -> void:
	paused = false
	get_tree().paused = false
	get_tree().change_scene_to_packed(Scenes.MainMenu)
