extends RigidBody2D

class_name Coin

signal coin_collected()

func _ready() -> void:
	linear_velocity = Vector2(0, 40)

func set_upgrade(_chr : String, color : Color) -> void:
	$Polygon2D.color = color
	
func _on_body_entered(body: Node) -> void:
	if body is Floor:
		get_parent().call_deferred("remove_child", self)
		call_deferred("queue_free")
		return
	if body is Paddle:
		coin_collected.emit()
		get_parent().call_deferred("remove_child", self)
		call_deferred("queue_free")
		
