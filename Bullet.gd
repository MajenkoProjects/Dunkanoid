extends RigidBody2D

signal hit_brick(brick : Node2D, power : int)
signal hit_alien(alien : Node2D, power : int)
signal hit_wall(wall : Node2D, power : int)

func _on_body_entered(body: Node) -> void:
	if body is Brick:
		if body.visible:
			hit_brick.emit(body, Global.get_laser_power())
			get_parent().call_deferred("remove_child", self)
			call_deferred("queue_free")
	if body is Alien:
		hit_alien.emit(body, Global.get_laser_power())
		get_parent().call_deferred("remove_child", self)
		call_deferred("queue_free")
	if body is Wall:
		hit_wall.emit(body, Global.get_laser_power())
		get_parent().call_deferred("remove_child", self)
		call_deferred("queue_free")
