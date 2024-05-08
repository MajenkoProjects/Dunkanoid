extends RigidBody2D

signal hit_brick(brick : Node2D)
signal hit_alien(alien : Node2D)
signal hit_wall(wall : Node2D)

func _on_body_entered(body: Node) -> void:
	if body is Brick:
		if body.visible:
			hit_brick.emit(body)
			get_parent().call_deferred("remove_child", self)
			call_deferred("queue_free")
	if body is Alien:
		hit_alien.emit(body)
		get_parent().call_deferred("remove_child", self)
		call_deferred("queue_free")
	if body is Wall:
		hit_wall.emit(body)
		get_parent().call_deferred("remove_child", self)
		call_deferred("queue_free")
