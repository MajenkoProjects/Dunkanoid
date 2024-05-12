@tool
extends SubViewportContainer

var count : float = 0

signal scroll_finished

@export var Dummy : int = 0 :
	set(x):
		Dummy = x
		_notification(NOTIFICATION_TRANSFORM_CHANGED)

func _ready() -> void:
	$SubViewport/ScrollContainer.scroll_vertical = 0
	set_notify_transform(true)
	material.set_shader_parameter("rect_global_position", global_position / get_viewport_rect().size)
	material.set_shader_parameter("rect_size", get_rect().size / get_viewport_rect().size * 24)	

func _process(delta : float) -> void:
	if Engine.is_editor_hint() == false:
		count += delta
		if count >= 0.1:
			count -= 0.1
			$SubViewport/ScrollContainer.scroll_vertical += 1
			var vbar = $SubViewport/ScrollContainer.get_v_scroll_bar()
			if vbar.value >= vbar.max_value - $SubViewport/ScrollContainer.size.y:
				scroll_finished.emit()

func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		var pos = global_position / get_viewport_rect().size
		material.set_shader_parameter("rect_global_position", pos)
		material.set_shader_parameter("rect_size", get_rect().size / get_viewport_rect().size * 24)

