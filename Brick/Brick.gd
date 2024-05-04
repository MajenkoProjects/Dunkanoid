extends StaticBody2D
class_name Brick

enum {
	NORMAL,
	SHINY,
	INVULNERABLE
}

signal brick_destroyed(brick : StaticBody2D)

var hits : int = 1
var value : int = 100
var original_color : Color = Color.WHITE
var my_type : int = NORMAL

func _ready() -> void:
	pass

func _process(_delta) -> void:
	pass

func hit() -> void:
	if hits <= 0:
		return
	hits -= 1
	if hits <= 0:
		collision_layer = 0
		if my_type == INVULNERABLE:
			hits = 2
			visible = false
			get_tree().create_timer(5).timeout.connect(_show_block)
			return
		brick_destroyed.emit(self)
		get_parent().remove_child(self)
		queue_free()
	else:
		var tween = create_tween()
		$TextureRect.modulate = Color(1, 1, 1)
		tween.tween_property($TextureRect, "modulate", original_color, 0.25)

func _show_block() -> void:
	$TextureRect.modulate = Color(1, 1, 1)
	var tween = create_tween()
	tween.tween_property($TextureRect, "modulate", original_color, 0.25)
	visible = true
	collision_layer = 1


func type(base : int, color : Color) -> void:
	my_type = base
	original_color = color
	match base:
		NORMAL:
			$TextureRect.texture = load("res://Brick/BaseBrick.png")
			$TextureRect.modulate = color
			hits = 1
			value = 100
		SHINY:
			$TextureRect.texture = load("res://Brick/ShinyBrick.png")
			$TextureRect.modulate = color
			hits = 2
			value = 200
		INVULNERABLE:
			$TextureRect.texture = load("res://Brick/InvulBrick.png")
			$TextureRect.modulate = color
			hits = 2
			value = 0
			
	
