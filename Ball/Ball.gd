extends RigidBody2D

const MIN_SPEED = 50.0
const MAX_SPEED = 500.0

signal hit_brick(ball : Node, brick : Node)
signal hit_paddle(ball : Node)
signal hit_floor(ball : Node)
signal hit_wall(ball : Node)

var captured : bool = false
var capture_object : Node2D
var capture_offset : Vector2 = Vector2.ZERO

var speed : float = 100
	
func _physics_process(delta: float) -> void:
#	angular_velocity = 0
	rotation = 0
	if captured:
		PhysicsServer2D.body_set_state(
			get_rid(),
			PhysicsServer2D.BODY_STATE_TRANSFORM,
			Transform2D.IDENTITY.translated(capture_object.global_position - capture_offset)
		)
		linear_velocity = Vector2.ZERO
		angular_velocity = 0
	else:
		if linear_velocity.length() != speed:
			linear_velocity = linear_velocity.normalized() * speed



func _on_body_entered(body: Node) -> void:
	pass

func capture(ob : Node2D, offset : Vector2 = Vector2.ZERO) -> void:
	captured = true
	capture_object = ob
	capture_offset = offset
	
func release() -> void:
	global_position = capture_object.global_position - capture_offset
	var diff = (global_position.x - capture_object.global_position.x) / (capture_object.width/2)
#	linear_velocity = Vector2(diff, -1).normalized() * 100
	apply_central_impulse(Vector2(diff, -1).normalized() * 1)
	captured = false
	capture_object = null



func _on_body_exited(body: Node) -> void:
	if body is Brick:
		if not body.visible:
			return
		$BrickSound.play()
		body.hit()
		hit_brick.emit(self, body)
		speed += 1
		return
	if body is Paddle:
		var diff = (position.x - body.position.x) / (body.width/2)
		linear_velocity = (Vector2(diff, -1).normalized()) * speed
		$PaddleSound.play()
		body.hit()
		hit_paddle.emit(self)
		return
	if body is Wall:
		if abs(linear_velocity.y) < 0.01:
			linear_velocity.y = randf() * 10.0
		elif abs(linear_velocity.y) < 1:
			linear_velocity.y *= 10.0
		$WallSound.play()
		hit_wall.emit(self)
		return
	if body is Floor:
		hit_floor.emit(self)
		return

func slowdown() -> void:
	speed = 100
