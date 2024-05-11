extends Node2D

var _Brick = preload("res://Brick/Brick.tscn")
var _Ball = preload("res://Ball/Ball.tscn")
var _Upgrade = preload("res://Upgrade/Upgrade.tscn")
var _Alien = preload("res://Alien.tscn")
var _Bullet = preload("res://Bullet.tscn")
var _Coin = preload("res://Coin/Coin.tscn")

@onready var ScoreNode = $ScoreCard/Score/ScoreBox
@onready var LivesNode = $ScoreCard/Lives/LivesBox
@onready var RunTimeNode = $ScoreCard/RunTime/RunTime
@onready var BestTimeNode = $ScoreCard/BestTime/BestTime
@onready var BricksNode = $Bricks
@onready var BackgroundNode = $Background
@onready var PaddleNode = $Paddle
@onready var PipesNode = $Pipes
@onready var AliensNode = $Aliens
@onready var RunTimerNode = $RunTimer
@onready var NewBestNode = $NewBestTime
@onready var NewBestTimeNode = $NewBestTime/HBoxContainer/BestTime
@onready var StartTitleNode = $Start/VBoxContainer/PanelContainer/VBoxContainer/Title
@onready var StartRoundNode = $Start/VBoxContainer/PanelContainer/VBoxContainer/Round
@onready var StartNode = $Start
@onready var PowerballTimerNode = $PowerBallTimer
@onready var FloorSoundNode = $Sounds/FloorSound
@onready var UpgradeSoundNode = $Sounds/UpgradeCollected
@onready var AlienDieSoundNode = $Sounds/AlienDie
@onready var CoinCollectedSoundNode = $Sounds/CoinCollected
@onready var TokenLabelNode = $Tokens/TokenLabel

var _Aliens : Array = [
	preload("res://Alien.tscn")
]

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
var level_starting : bool = false
var time_run : bool = false

func _ready() -> void:
	level = Global.start_level
	lives = Global.get_lives()
	TokenLabelNode.text = "%d" % Global.upgrade_tokens
	EventBus.upgrade_tokens_updated.connect(_on_upgrade_tokens_updated)
	
	if Global.relative_mouse:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)

	EventBus.update_score.connect(_on_update_score)
	new_level()
	Music.play_game()

var opened: bool = false

func _process(delta : float) -> void:
	
	if OS.has_feature("editor"):
		if Input.is_action_pressed("cheat"):
			fire_bullet()
	
	if PaddleNode.is_laser():
		if Input.is_action_just_pressed("fire"):
			fire_bullet()
				
	if mode == MODE_EXIT:
		if PaddleNode.global_position.x - (PaddleNode.width / 2) <= 20:
			level = level_data.left
			leave(-1)
		if PaddleNode.global_position.x + (PaddleNode.width / 2) >= 412:
			level = level_data.right
			leave(+1)
	
	if mode == MODE_LEAVE:
		PaddleNode.global_position.x += (delta * leave_direction * 20.0)		
		if PaddleNode.global_position.x < -16 or PaddleNode.global_position.x > 462:
			if level == "NOTFOUND" and not Music.jingle_playing:
				get_tree().change_scene_to_file("res://Intro.tscn")
				return
			if opened:
				PipesNode.close_door(Pipes.BOTTOM_LEFT)
				PipesNode.close_door(Pipes.BOTTOM_RIGHT)
				opened = false
			if not Music.jingle_playing:
				new_level()
	else:
		if Input.is_action_pressed("left"):
			var leftmost = 16 + PaddleNode.width / 2
			PaddleNode.position.x -= delta * PADDLE_SPEED
			PaddleNode.position.y = 340
			if PaddleNode.position.x < leftmost:
				PaddleNode.position.x = leftmost
		if Input.is_action_pressed("right"):
			var rightmost = 432 - PaddleNode.width / 2
			PaddleNode.position.x += delta * PADDLE_SPEED
			PaddleNode.position.y = 340
			if PaddleNode.position.x > rightmost:
				PaddleNode.position.x = rightmost
		if Input.is_action_just_pressed("fire"):
			if mode == MODE_PLAY:
				if level_starting:
					level_starting = false
					RunTimerNode.start()
					time_run = true
				for ball in balls:
					if (ball.captured):
						ball.release()


	if time_run:
		RunTimeNode.text = "%02d:%05.2f" % [RunTimerNode.elapsed_time / 60000, RunTimerNode.elapsed_time % 60000 / 1000.0]


func leave(dir : int) -> void:
	mode = MODE_LEAVE
	leave_direction = dir

func new_level() -> void:
	NewBestNode.visible = false
	time_run = false
	level_starting = true
	PaddleNode.normal()
	PaddleNode.position.x = 224
	mode = MODE_WAIT
	for ball in balls:
		call_deferred("remove_child", ball)
		ball.call_deferred("queue_free")
	balls.clear()
	for brick in bricks:
		BricksNode.call_deferred("remove_child", brick)
		brick.call_deferred("queue_free")
	bricks.clear()
	chr += 1
	level_data = load_level_from_disk(level)
	BestTimeNode.text = format_time(Global.get_best_time(level_data.name))
	StartTitleNode.text = level
	StartRoundNode.text = "ROUND %3d" % [chr]
	BackgroundNode.texture = load("res://Backgrounds/%s.png" % level_data.background)
	BackgroundNode.modulate = Color("#%s" % level_data.get("tint", "FFFFFF"))
	load_level(level_data.data)
	var ball = _Ball.instantiate()
	ball.capture(PaddleNode, Vector2((randf() * 32) - 16, 8))
	ball.hit_paddle.connect(_on_hit_paddle)
	ball.hit_floor.connect(_on_hit_floor)
	add_child(ball)
	balls.push_back(ball)

	StartNode.visible = true
	Music.jingle_finished.connect(_on_start_round_finished)
	Music.jingle(Music.JINGLE_LEVEL_START)
	
func _brick_destroyed(brick) -> void:
	Global.score += brick.value
	if randf() >= Global.get_powerup_percent():
		var upgrade = _Upgrade.instantiate()
		upgrade.position = brick.position
		upgrade.upgrade_collected.connect(_on_upgrade_collected)
		match randi() % 7:
			0:
				upgrade.set_upgrade("C", Color.BLUE)
			1:
				upgrade.set_upgrade("D", Color.GREEN)
			2:
				upgrade.set_upgrade("S", Color.CYAN)
			3:
				upgrade.set_upgrade("E", Color.DARK_SEA_GREEN)
			4:
				upgrade.set_upgrade("R", Color.LIGHT_CORAL)
			5:
				upgrade.set_upgrade("P", Color.AQUAMARINE)
			6:
				upgrade.set_upgrade("L", Color.GOLD)
		call_deferred("add_child", upgrade)
	bricks.erase(brick)
	var brick_count = 0
	for abrick in bricks:
		if abrick.my_type != Brick.INVULNERABLE:
			brick_count += 1
		
	if brick_count == 0:
		RunTimerNode.pause()
		for ball in balls:
			call_deferred("remove_child", ball)
			ball.call_deferred("queue_free")
		balls.clear()

		for c in get_children():
			if c is Upgrade:
				call_deferred("remove_child", c)
				c.call_deferred("queue_free")

		for c in AliensNode.get_children():
			AliensNode.call_deferred("remove_child", c)
			c.call_deferred("queue_free")

		mode = MODE_EXIT
		PipesNode.open_door(Pipes.BOTTOM_LEFT)
		PipesNode.open_door(Pipes.BOTTOM_RIGHT)
		opened = true
		Music.jingle(Music.JINGLE_LEVEL_WON)
		var elapsed = RunTimerNode.elapsed_time
		var best = Global.get_best_time(level_data.name)
		if elapsed < best:
			Global.set_best_time(level_data.name, elapsed)
			RunTimerNode.pause()
			NewBestTimeNode.text = format_time(elapsed)
			NewBestNode.visible = true

func format_time(time : int) -> String:
	if time > 3600000:
		return "--:--.--"
	return "%02d:%05.2f" % [int(time / 60000.0), time % 60000 / 1000.0]
	
func _input(event: InputEvent) -> void:
	if paused:
		return
	if event is InputEventMouseMotion:
		if mode != MODE_LEAVE:
			if Global.relative_mouse:
				var leftmost = 16 + PaddleNode.width / 2
				var rightmost = 432 - PaddleNode.width / 2
				PaddleNode.position.x += event.relative.x
				PaddleNode.position.y = 340
				if PaddleNode.position.x < leftmost:
					PaddleNode.position.x = leftmost
				if PaddleNode.position.x > rightmost:
					PaddleNode.position.x = rightmost
			else:
				PaddleNode.position = Vector2(min(max(16 + PaddleNode.width/2, event.position.x), 432-PaddleNode.width/2), 340)
	if event is InputEventMouseButton:
		if event.pressed:
			if mode == MODE_PLAY:
				if PaddleNode.is_laser():
					fire_bullet()
				if level_starting:
					RunTimerNode.start()
					level_starting = false
					time_run = true

				for ball in balls:
					if (ball.captured):
						ball.release()

func _on_hit_paddle(ball, _power) -> void:
	if PaddleNode.is_capture():
		var diff = PaddleNode.global_position.x - ball.global_position.x
		ball.capture(PaddleNode, Vector2(diff, 8))

func _on_hit_floor(ball, _power) -> void:
	FloorSoundNode.play()
	balls.erase(ball)
	call_deferred("remove_child", ball)
	ball.call_deferred("queue_free")
	if balls.size() == 0:
		for c in get_children():
			if c is Upgrade:
				call_deferred("remove_child", c)
				c.call_deferred("queue_free")
		PaddleNode.normal()
		ball = _Ball.instantiate()
		ball.capture(PaddleNode, Vector2((randf() * 32) - 16, 8))
		ball.hit_paddle.connect(_on_hit_paddle)
		ball.hit_floor.connect(_on_hit_floor)
		call_deferred("add_child", ball)
		balls.push_back(ball)
		Music.jingle_finished.connect(_on_start_round_finished)
		Music.jingle(Music.JINGLE_LEVEL_START)
		StartNode.visible = true
		mode = MODE_WAIT
		lives -= 1
		if lives <= 0:
			get_tree().change_scene_to_file("res://GameOver.tscn")


func _on_round_won_finished() -> void:
	pass


func _on_update_score(score) -> void:
	ScoreNode.text = "%08d" % score
	pass # Replace with function body.

func _on_upgrade_collected(code : String) -> void:
	UpgradeSoundNode.play()
	match code:
		"C":
			PaddleNode.capture()
		"D":
			for i in Global.get_num_balls() - 1:
				add_ball()
		"S":
			for ball in balls:
				ball.slowdown()
		"E":
			PaddleNode.big()
		"R":
			PaddleNode.small()
		"P":
			start_powerball()
		"L":
			PaddleNode.laser()

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
	if balls[0].is_sparkles():
		newball.enable_sparkles()
	if balls[0].captured:
		newball.capture(PaddleNode, Vector2((randf() - 0.5) * 32, 8))
	call_deferred("add_child", newball)
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
			BricksNode.add_child(brick)

func _on_start_round_finished(_item : int) -> void:
	Music.jingle_finished.disconnect(_on_start_round_finished)
	StartNode.visible = false
	mode = MODE_PLAY

func _on_update_lives() -> void:
	LivesNode.text = "%d" % lives

func load_level_from_disk(lname : String) -> Dictionary:
	if FileAccess.file_exists("user://Levels/%s.json" % lname):
		return JSON.parse_string(FileAccess.get_file_as_string("user://Levels/%s.json" % lname))
	if FileAccess.file_exists("res://Levels/%s.json" % lname):
		return JSON.parse_string(FileAccess.get_file_as_string("res://Levels/%s.json" % lname))
	return JSON.parse_string(FileAccess.get_file_as_string("res://Levels/NOTFOUND.json"))

func _on_paddle_effect_finished(effect: int) -> void:
	if effect == Paddle.PADDLE_CAPTURE:
		for ball in balls:
			if ball.captured:
				ball.release()

func start_powerball() -> void:
	for ball in balls:
		ball.enable_sparkles()
	for brick in BricksNode.get_children():
		brick.enable_pass()
	PowerballTimerNode.start(Global.get_effect_time())

func stop_powerball() -> void:
	for ball in balls:
		ball.disable_sparkles()
	for brick in BricksNode.get_children():
		brick.disable_pass()


func _on_power_ball_timer_timeout() -> void:
	stop_powerball()

func spawn_alien() -> void:
	if AliensNode.get_child_count() < 3:
		var door : int = Pipes.TOP_LEFT if randf() < 0.5 else Pipes.TOP_RIGHT
		PipesNode.open_door(door)
	
func _on_pipes_door_opened(door) -> void:
	match door:
		Pipes.TOP_LEFT:
			var alien = _Aliens.pick_random().instantiate()
			alien.position = Vector2(96, -12)
			alien.velocity = Vector2(0, 50)
			alien.alien_died.connect(_alien_died)
			AliensNode.add_child(alien)
			get_tree().create_timer(2).timeout.connect(_close_top_left)
			pass
		Pipes.TOP_RIGHT:
			var alien = _Aliens.pick_random().instantiate()
			alien.position = Vector2(352, -12)
			alien.velocity = Vector2(0, 50)
			alien.alien_died.connect(_alien_died)
			AliensNode.add_child(alien)
			get_tree().create_timer(2).timeout.connect(_close_top_right)
			pass

func _close_top_left() -> void:
	PipesNode.close_door(Pipes.TOP_LEFT)

func _close_top_right() -> void:
	PipesNode.close_door(Pipes.TOP_RIGHT)

func _on_alien_timer_timeout() -> void:
	spawn_alien()

func _alien_died(alien : Node2D, points : int) -> void:
	var pos : Vector2 = alien.global_position
	Global.score += points
	AlienDieSoundNode.play()
	var coin = _Coin.instantiate()
	coin.global_position = pos
	coin.coin_collected.connect(_on_coin_collected)
	call_deferred("add_child", coin)
	
func fire_bullet() -> void:
	var bullet = _Bullet.instantiate()
	bullet.global_position = PaddleNode.global_position - Vector2(0, 8)
	bullet.hit_brick.connect(_on_bullet_hit_brick)
	bullet.hit_alien.connect(_on_bullet_hit_alien)
	add_child(bullet)
	bullet.linear_velocity = Vector2(0, -500)

func _on_bullet_hit_brick(node, power) -> void:
	node.hit(power)

func _on_bullet_hit_alien(node, power) -> void:
	node.hit(power)

func _on_coin_collected() -> void:
	CoinCollectedSoundNode.play()
	Global.upgrade_tokens += 1

func _on_upgrade_tokens_updated(qty : int) -> void:
	TokenLabelNode.text = "%d" % qty
