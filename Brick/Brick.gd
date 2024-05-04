extends StaticBody2D
class_name Brick

signal brick_destroyed(brick : StaticBody2D)

@export var hits : int = 1
@export var value : int = 100
@export var color : Color :
	set(c):
		color = c
		if $Polygon2D != null:
			$Polygon2D.color = c

func _init() -> void:
	name = "Brick"

func _ready() -> void:
	pass

func _process(_delta) -> void:
	pass

func hit() -> void:
	if hits <= 0:
		return
	hits -= 1
	var tween = create_tween()
	$Polygon2D.color = Color(1, 1, 1)
	tween.tween_property($Polygon2D, "color", color, 0.25)
	tween.tween_callback(_hitfade_done)
	if hits <= 0:
		brick_destroyed.emit(self)

func _hitfade_done() -> void:
	if hits <= 0:
		get_parent().remove_child(self)
		queue_free()
