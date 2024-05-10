extends CharacterBody2D

class_name Alien

signal alien_died(alien : Node2D, value : int)

@export var hits : int = 5
@export var points : int = 500

func _ready() -> void:
	$Sprite2D.play("default")
	move_random()

func move_random() -> void:
	velocity = Vector2(randf() - 0.5, randf() - 0.5).normalized() * 30
	get_tree().create_timer(randf() * 3).timeout.connect(move_random)

func _physics_process(delta: float) -> void:
	if position.y < 28:
		position.y += delta * 30
	else:
		move_and_slide()

func hit(power : int) -> void:
	hits -= power
	if hits <= 0:
		alien_died.emit(self, points)
		get_parent().call_deferred("remove_child", self)
		call_deferred("queue_free")	
	else:
		$AlienSound.play()
		var tween = get_tree().create_tween()
		$Sprite2D.modulate = Color(1, 1, 1, 0)
		tween.tween_property($Sprite2D, "modulate", Color(1, 1, 1, 1), 0.3)
