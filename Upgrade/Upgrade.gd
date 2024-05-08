extends RigidBody2D

class_name Upgrade

signal upgrade_collected(char : String)

var character = "C"

func _ready() -> void:
	linear_velocity = Vector2(0, 40)

func set_upgrade(chr : String, color : Color) -> void:
	character = chr
	$Label.text = character
	$Polygon2D.color = color
	
func _on_body_entered(body: Node) -> void:
	if body is Floor:
		get_parent().call_deferred("remove_child", self)
		call_deferred("queue_free")
		return
	if body is Paddle:
		upgrade_collected.emit(character)
		get_parent().call_deferred("remove_child", self)
		call_deferred("queue_free")
		
