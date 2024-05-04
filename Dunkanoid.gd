extends Node2D

var Brick = preload("res://Brick/Brick.tscn")
var Ball = preload("res://Ball/Ball.tscn")
var Upgrade = preload("res://Upgrade/Upgrade.tscn")

var bricks : Array = []
var balls : Array[Node] = []

signal update_score

var capture_mode : bool = false
var lives : int = 3
var score : int = 0 :
	set(x):
		score = x
		update_score.emit()

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	new_level()

func new_level() -> void:
	for ball in balls:
		remove_child(ball)
		ball.queue_free()
	for y in 8:
		for x in 16:
			var brick = Brick.instantiate()
			brick.color = Color(randf(), randf(), randf())
			brick.position = Vector2(x * 32 + 16, y * 16 + 8 + 32)
			bricks.push_back(brick)
			brick.brick_destroyed.connect(_brick_destroyed)
			add_child(brick)
	var ball = Ball.instantiate()
	ball.capture($Paddle, Vector2((randf() * 32) - 16, 8))
	ball.hit_paddle.connect(_on_hit_paddle)
	ball.hit_floor.connect(_on_hit_floor)
	add_child(ball)
	balls.push_back(ball)
	
	$StartRound.play()

	
func _brick_destroyed(brick) -> void:
	score += brick.value
	if randf() > 0.9:
		var upgrade = Upgrade.instantiate()
		upgrade.position = brick.position
		upgrade.upgrade_collected.connect(_on_upgrade_collected)
		match randi() % 3:
			0:
				upgrade.set_upgrade("C", Color.BLUE)
			1:
				upgrade.set_upgrade("T", Color.GREEN)
			2:
				upgrade.set_upgrade("X", Color.RED)
		add_child(upgrade)
	bricks.erase(brick)
	if bricks.size() == 0:
		for ball in balls:
			remove_child(ball)
			ball.queue_free()
			balls.erase(ball)
		$RoundWon.play()

	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		$Paddle.position = Vector2(min(max(16, event.position.x), 512-16), 340)
	if event is InputEventMouseButton:
		for ball in balls:
			if (ball.captured):
				ball.release()

func _on_hit_paddle(ball) -> void:
	if capture_mode:
		var diff = $Paddle.global_position.x - ball.global_position.x
		ball.capture($Paddle, Vector2(diff, 8))

func _on_hit_floor(ball) -> void:
	$FloorSound.play()
	print("Hit floor!")
	balls.erase(ball)
	remove_child(ball)
	ball.call_deferred("queue_free")
	if balls.size() == 0:
		ball = Ball.instantiate()
		ball.capture($Paddle, Vector2((randf() * 32) - 16, 8))
		ball.hit_paddle.connect(_on_hit_paddle)
		ball.hit_floor.connect(_on_hit_floor)
		add_child(ball)
		balls.push_back(ball)
		$StartRound.play()


func _on_round_won_finished() -> void:
	new_level()


func _on_update_score() -> void:
	$ScoreBox.text = "%08d" % score
	pass # Replace with function body.

func _on_upgrade_collected(code : String) -> void:
	match code:
		"C":
			capture_mode = true
			get_tree().create_timer(10).timeout.connect(_cancel_capture_mode)
		"T":
			add_ball()
			add_ball()
		"X":
			for i in 10:
				add_ball()

func add_ball() -> void:
	var newball = Ball.instantiate()
	newball.position = balls[0].position
	newball.linear_velocity = balls[0].linear_velocity - Vector2((randf() - 0.5) * 30 , 0)
	newball.angular_velocity = 0
	newball.hit_paddle.connect(_on_hit_paddle)
	newball.hit_floor.connect(_on_hit_floor)
	add_child(newball)
	balls.push_back(newball)
	
			
func _cancel_capture_mode() -> void:
	capture_mode = false
