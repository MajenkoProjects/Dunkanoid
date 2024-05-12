extends AnimatedSprite2D

func _ready() -> void:
	play()

func _on_animation_finished() -> void:
	get_parent().remove_child(self)
	queue_free()
