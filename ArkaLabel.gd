@tool
extends Label

class_name ArkaLabel

func _ready() -> void:
	set_notify_transform(true)
	material = load("res://ArkanoidMaterial.tres").duplicate()
	theme = load("res://MainTheme.tres")
	theme_type_variation = "Arkanoid"
	material.set_shader_parameter("rect_global_position", global_position / get_viewport_rect().size)
	material.set_shader_parameter("rect_size", get_rect().size)

func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		var pos = global_position / get_viewport_rect().size
		print(pos)
		material.set_shader_parameter("rect_global_position", pos)
		material.set_shader_parameter("rect_size", get_rect().size)
		
