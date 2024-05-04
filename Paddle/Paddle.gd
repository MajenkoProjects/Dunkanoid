extends StaticBody2D
class_name Paddle

var width : int :
	get:
		return $CollisionShape2D.shape.size.x

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass # Replace with function body.

func hit() -> void:
	pass
