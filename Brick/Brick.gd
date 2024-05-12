extends StaticBody2D
class_name Brick

enum {
	NORMAL,
	SILVER,
	GOLD,
	INVULNERABLE
}

signal brick_destroyed(brick : StaticBody2D, is_laser : bool )

var hits : int = 1
var value : int = 100
var original_color : Color = Color.WHITE
var my_type : int = NORMAL
var pass_mode : bool = false

func _ready() -> void:
	pass

func _process(_delta) -> void:
	pass

func hit(power : int, is_laser : bool = false) -> void:
	if hits <= 0:
		return
	hits -= power
	if hits <= 0:
		collision_layer = 0
		if my_type == INVULNERABLE:
			hits = 2
			visible = false
			get_tree().create_timer(5).timeout.connect(_show_block)
			return
		brick_destroyed.emit(self, is_laser)
		get_parent().call_deferred("remove_child", self)
		call_deferred("queue_free")
	else:
		var tween = create_tween()
		$TextureRect.modulate = Color(1, 1, 1)
		tween.tween_property($TextureRect, "modulate", original_color, 0.25)

func _show_block() -> void:
	$TextureRect.modulate = Color(1, 1, 1)
	var tween = create_tween()
	tween.tween_property($TextureRect, "modulate", original_color, 0.25)
	visible = true
	if not pass_mode:
		collision_layer = 0b10001


func type(base : int, color : Color) -> void:
	my_type = base
	original_color = color
	match base:
		NORMAL:
			$TextureRect.texture = Global.Bricks["base"]
			$TextureRect.modulate = color
			hits = 1
			value = 100
		SILVER:
			$TextureRect.texture = Global.Bricks["shiny"]
			$TextureRect.modulate = color
			hits = 2
			value = 200
		GOLD:
			$TextureRect.texture = Global.Bricks["shiny"]
			$TextureRect.modulate = color
			hits = 3
			value = 500
		INVULNERABLE:
			$TextureRect.texture = Global.Bricks["invul"]
			$TextureRect.modulate = color
			hits = 2
			value = 0

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not pass_mode: return
	if body is Ball:
		body._on_body_exited(self)

func enable_pass() -> void:
	collision_layer = 0b10000
	pass_mode = true
	
func disable_pass() -> void:
	if visible:
		collision_layer = 0b10001
	pass_mode = false
