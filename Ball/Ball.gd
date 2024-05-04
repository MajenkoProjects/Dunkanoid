extends RigidBody2D

const MIN_SPEED = 100.0

signal hit_brick(ball : Node, brick : Node)
signal hit_paddle(ball : Node)
signal hit_floor(ball : Node)
signal hit_wall(ball : Node)

var captured : bool = false
var capture_object : Node2D
var capture_offset : Vector2 = Vector2.ZERO
	
func _physics_process(delta: float) -> void:
	if captured:
		PhysicsServer2D.body_set_state(
			get_rid(),
			PhysicsServer2D.BODY_STATE_TRANSFORM,
			Transform2D.IDENTITY.translated(capture_object.global_position - capture_offset)
		)
		linear_velocity = Vector2.ZERO
		angular_velocity = 0
	else:
		if linear_velocity.length() < MIN_SPEED:
			linear_damp = 0
			linear_velocity = linear_velocity.normalized() * MIN_SPEED

func _on_body_entered(body: Node) -> void:
	if body is Brick:
		#linear_velocity = (linear_velocity.normalized() + (Vector2(randf() - 0.5, randf() - 0.5) / 2.0)).normalized() * linear_velocity.length()
		$BrickSound.play()
		body.hit()
		hit_brick.emit(self, body)
		return
	if body is Paddle:
		var diff = (position.x - body.position.x) / (body.width/2)
		linear_velocity = (Vector2(diff, -1).normalized()) * linear_velocity.length() 
		$PaddleSound.play()
		body.hit()
		hit_paddle.emit(self)
		return
	if body is Wall:
		if abs(linear_velocity.y) < 0.01:
			linear_velocity.y = randf() * 10.0
		elif abs(linear_velocity.y) < 1:
			linear_velocity.y *= 10.0
		#linear_velocity = (linear_velocity.normalized() + (Vector2(randf() - 0.5, randf() - 0.5) / 5.0)).normalized() * linear_velocity.length()
		$WallSound.play()
		hit_wall.emit(self)
		return
	if body is Floor:
		#$FloorSound.play()
		hit_floor.emit(self)
		return

func capture(ob : Node2D, offset : Vector2 = Vector2.ZERO) -> void:
	captured = true
	capture_object = ob
	capture_offset = offset
	
func release() -> void:
	global_position = capture_object.global_position - capture_offset
	var diff = (global_position.x - capture_object.global_position.x) / (capture_object.width/2)
	linear_velocity = Vector2(diff, -1).normalized() * 100
	captured = false
	capture_object = null

