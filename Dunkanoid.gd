extends Node2D

var _Brick = preload("res://Brick/Brick.tscn")
var _Ball = preload("res://Ball/Ball.tscn")
var _Upgrade = preload("res://Upgrade/Upgrade.tscn")

var bricks : Array = []
var balls : Array[Node] = []

const PADDLE_SPEED : float = 150

enum {
	MODE_WAIT,
	MODE_PLAY,
	MODE_EXIT,
	MODE_LEAVE
}

var mode = MODE_WAIT
var chr : int = 0
signal update_lives

var lives : int = 3 :
	set(x):
		lives = x
		update_lives.emit()

var level : String = "DUNKANOID"

var level_data : Dictionary = {}

var leave_direction : int = 0

var paused : bool = false

func _ready() -> void:
	if Global.relative_mouse:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)

	EventBus.update_score.connect(_on_update_score)
	new_level()

func _process(delta : float) -> void:
	
	if OS.has_feature("editor"):
		if Input.is_action_just_pressed("cheat"):
			var upgrade = _Upgrade.instantiate()
			upgrade.position = balls[0].position
			upgrade.upgrade_collected.connect(_on_upgrade_collected)
			upgrade.set_upgrade("C", Color.BLUE)
			add_child(upgrade)
			#for i in 10:
				#add_ball()
				
	if mode == MODE_EXIT:
		if $Paddle.global_position.x - ($Paddle.width / 2) <= 20:
			level = level_data.left
			leave(-1)
		if $Paddle.global_position.x + ($Paddle.width / 2) >= 412:
			level = level_data.right
			leave(+1)
	
	if mode == MODE_LEAVE:
		$Paddle.global_position.x += (delta * leave_direction * 20.0)
		if $Paddle.global_position.x < -16 or $Paddle.global_position.x > 428:
			if not $Sounds/RoundWon.playing:
				new_level()
	else:
		if Input.is_action_pressed("left"):
			var leftmost = 16 + $Paddle.width / 2
			$Paddle.position.x -= delta * PADDLE_SPEED
			$Paddle.position.y = 340
			if $Paddle.position.x < leftmost:
				$Paddle.position.x = leftmost
		if Input.is_action_pressed("right"):
			var rightmost = 432 - $Paddle.width / 2
			$Paddle.position.x += delta * PADDLE_SPEED
			$Paddle.position.y = 340
			if $Paddle.position.x > rightmost:
				$Paddle.position.x = rightmost
		if Input.is_action_just_pressed("fire"):
			if mode == MODE_PLAY:
				for ball in balls:
					if (ball.captured):
						ball.release()


func leave(dir : int) -> void:
	mode = MODE_LEAVE
	leave_direction = dir

func new_level() -> void:
	$Paddle.normal()
	$Paddle.position.x = 224
	mode = MODE_WAIT
	$Exits.visible = false
	for ball in balls:
		remove_child(ball)
		ball.queue_free()
	balls.clear()
	for brick in bricks:
		$Bricks.remove_child(brick)
		brick.queue_free()
	bricks.clear()
	chr += 1
	level_data = load_level_from_disk(level)

	$Start/Title.text = level
	$Start/Round.text = "ROUND %3d" % [chr]
	$Background.texture = load("res://Backgrounds/%s.png" % level_data.background)
	load_level(level_data.data)
	var ball = _Ball.instantiate()
	ball.capture($Paddle, Vector2((randf() * 32) - 16, 8))
	ball.hit_paddle.connect(_on_hit_paddle)
	ball.hit_floor.connect(_on_hit_floor)
	add_child(ball)
	balls.push_back(ball)

	$Start.visible = true
	$Sounds/StartRound.play()

	
func _brick_destroyed(brick) -> void:
	Global.score += brick.value
	if randf() > 0.9:
		var upgrade = _Upgrade.instantiate()
		upgrade.position = brick.position
		upgrade.upgrade_collected.connect(_on_upgrade_collected)
		match randi() % 5:
			0:
				upgrade.set_upgrade("C", Color.BLUE)
			1:
				upgrade.set_upgrade("T", Color.GREEN)
			2:
				upgrade.set_upgrade("S", Color.CYAN)
			3:
				upgrade.set_upgrade("E", Color.DARK_SEA_GREEN)
			4:
				upgrade.set_upgrade("R", Color.LIGHT_CORAL)
		add_child(upgrade)
	bricks.erase(brick)
	var brick_count = 0
	for abrick in bricks:
		if abrick.my_type != Brick.INVULNERABLE:
			brick_count += 1
		
	if brick_count == 0:
		for ball in balls:
			remove_child(ball)
			ball.queue_free()
		balls.clear()

		for c in get_children():
			if c is Upgrade:
				remove_child(c)
				c.queue_free()

		mode = MODE_EXIT
		$Exits.visible = true
		$Sounds/RoundWon.play()

	
func _input(event: InputEvent) -> void:
	if paused:
		return
	if event is InputEventMouseMotion:
		if mode != MODE_LEAVE:
			if Global.relative_mouse:
				var leftmost = 16 + $Paddle.width / 2
				var rightmost = 432 - $Paddle.width / 2
				$Paddle.position.x += event.relative.x
				$Paddle.position.y = 340
				if $Paddle.position.x < leftmost:
					$Paddle.position.x = leftmost
				if $Paddle.position.x > rightmost:
					$Paddle.position.x = rightmost
			else:
				$Paddle.position = Vector2(min(max(16 + $Paddle.width/2, event.position.x), 432-$Paddle.width/2), 340)
	if event is InputEventMouseButton:
		if mode != MODE_PLAY:
			return
		for ball in balls:
			if (ball.captured):
				ball.release()

func _on_hit_paddle(ball) -> void:
	if $Paddle.is_capture():
		var diff = $Paddle.global_position.x - ball.global_position.x
		ball.capture($Paddle, Vector2(diff, 8))

func _on_hit_floor(ball) -> void:
	$Sounds/FloorSound.play()
	balls.erase(ball)
	remove_child(ball)
	ball.call_deferred("queue_free")
	if balls.size() == 0:
		for c in get_children():
			if c is Upgrade:
				remove_child(c)
				c.queue_free()
		$Paddle.normal()
		ball = _Ball.instantiate()
		ball.capture($Paddle, Vector2((randf() * 32) - 16, 8))
		ball.hit_paddle.connect(_on_hit_paddle)
		ball.hit_floor.connect(_on_hit_floor)
		add_child(ball)
		balls.push_back(ball)
		$Sounds/StartRound.play()
		$Start.visible = true
		mode = MODE_WAIT
		lives -= 1
		if lives <= 0:
			get_tree().change_scene_to_file("res://GameOver.tscn")


func _on_round_won_finished() -> void:
	pass


func _on_update_score(score) -> void:
	$ScoreBox.text = "%08d" % score
	pass # Replace with function body.

func _on_upgrade_collected(code : String) -> void:
	$Sounds/UpgradeCollected.play()
	match code:
		"C":
			$Paddle.capture()
		"T":
			add_ball()
			add_ball()
		"S":
			for ball in balls:
				ball.slowdown()
		"E":
			$Paddle.big()
		"R":
			$Paddle.small()

func add_ball() -> void:
	if balls.size() == 0: 
		return
	var newball = _Ball.instantiate()
	newball.position = balls[0].position
	newball.linear_velocity = (balls[0].linear_velocity - Vector2((randf() - 0.5) * 180 , 0)).normalized() * balls[0].linear_velocity.length()
	newball.angular_velocity = 0
	newball.hit_paddle.connect(_on_hit_paddle)
	newball.hit_floor.connect(_on_hit_floor)
	newball.speed = balls[0].speed
	if balls[0].captured:
		newball.capture($Paddle, Vector2((randf() - 0.5) * 32, 8))
	add_child(newball)
	balls.push_back(newball)
	


func load_level(data) -> void:
	for y in data.size():
		var line : String = data[y]
		for x in line.length():
			var c = line.substr(x, 1)
			if c == " ":
				continue
				
			var brick = _Brick.instantiate()
			match c:
				"R":
					brick.type(Brick.NORMAL, Color.RED)
				"G":
					brick.type(Brick.NORMAL, Color.GREEN)
				"Y":
					brick.type(Brick.NORMAL, Color.YELLOW)
				"B":
					brick.type(Brick.NORMAL, Color.ROYAL_BLUE)
				"M":
					brick.type(Brick.NORMAL, Color.MAGENTA)
				"C":
					brick.type(Brick.NORMAL, Color.CYAN)
				"W":
					brick.type(Brick.NORMAL, Color.WHITE)
				"O":
					brick.type(Brick.NORMAL, Color.ORANGE)
				"s":
					brick.type(Brick.SILVER, Color.SILVER)
				"g":
					brick.type(Brick.GOLD, Color.GOLD)
				"i":
					brick.type(Brick.INVULNERABLE, Color.GRAY)

			brick.position = Vector2(x * 32 + 16 + 16, y * 16 + 8 + 16)
			bricks.push_back(brick)
			brick.brick_destroyed.connect(_brick_destroyed)
			$Bricks.add_child(brick)

func _on_start_round_finished() -> void:
	$Start.visible = false
	mode = MODE_PLAY

func _on_update_lives() -> void:
	$LivesBox.text = "%d" % lives

func load_level_from_disk(name : String) -> Dictionary:
	if FileAccess.file_exists("user://Levels/%s.json" % name):
		return JSON.parse_string(FileAccess.get_file_as_string("user://Levels/%s.json" % name))
	if FileAccess.file_exists("res://Levels/%s.json" % name):
		return JSON.parse_string(FileAccess.get_file_as_string("res://Levels/%s.json" % name))
	return JSON.parse_string(FileAccess.get_file_as_string("res://Levels/NOTFOUND.json"))

func _on_paddle_effect_finished(effect: int) -> void:
	if effect == Paddle.PADDLE_CAPTURE:
		for ball in balls:
			if ball.captured:
				ball.release()
