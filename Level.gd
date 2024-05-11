@tool
extends SubViewport

class_name Level

signal level_cleared
signal brick_destroyed(brick : Node2D)

var _Brick = preload("res://Brick/Brick.tscn")

var Background : TextureRect
var BricksNode : Node2D

var bricks : Array = []
var level_data : Dictionary = {}

@export var LevelName : String = "DUNKANOID" : 
	set(x):
		LevelName = x
		load_level(LevelName)



func _ready() -> void:
	size = Vector2(448, 360)

	Background = TextureRect.new()
	Background.size = Vector2(448, 360)
	Background.expand_mode = TextureRect.EXPAND_KEEP_SIZE
	Background.stretch_mode = TextureRect.STRETCH_TILE
	Background.z_index = -2
	add_child(Background)
	
	BricksNode = Node2D.new()
	add_child(BricksNode)

	load_level(LevelName)
	#Background = TextureRect.new()
	#Background.size = Vector2(448, 360)
	#Background.expand_mode = TextureRect.EXPAND_KEEP_SIZE
	#Background.stretch_mode = TextureRect.STRETCH_TILE
	#Background.z_index = -2
	#add_child(Background)
	#
	#BricksNode = Node2D.new()
	#add_child(BricksNode)

func load_level(level_name : String) -> void:
	if FileAccess.file_exists("user://Levels/%s.json" % level_name):
		load_from_file("user://Levels/%s.json" % level_name)
		return
	if FileAccess.file_exists("res://Levels/%s.json" % level_name):
		load_from_file("res://Levels/%s.json" % level_name)
		return
	push_warning("Level %s unknown" % level_name)

func load_from_file(filename : String) -> void:
	print("Loading %s" % filename)
	var data = JSON.parse_string(FileAccess.get_file_as_string(filename))
	if data != null:
		load_from_data(data)
		return
	push_warning("Corrupt JSON in %s" % filename)

func load_from_data(data : Dictionary) -> void:
	purge_bricks()
	level_data = data
	Background.texture = load("res://Backgrounds/%s.png" % level_data.background)
	Background.modulate = Color("#%s" % level_data.get("tint", "FFFFFF"))
	for y in level_data.data.size():
		var line : String = level_data.data[y]
		for x in line.length():
			var c = line.substr(x, 1)
			if c == " ":
				continue
			
			if not Engine.is_editor_hint():
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


func purge_bricks() -> void:
	for brick in bricks:
		BricksNode.call_deferred("remove_child", brick)
		brick.call_deferred("queue_free")
	bricks.clear()

func _brick_destroyed(brick : Node2D) -> void:

	if brick.my_type != Brick.INVULNERABLE:	
		brick_destroyed.emit(brick)
		bricks.erase(brick)	
		BricksNode.call_deferred("remove_child", brick)
		brick.call_deferred("queue_free")

	var brick_count = 0
	for abrick in bricks:
		if abrick.my_type != Brick.INVULNERABLE:
			brick_count += 1
		
	if brick_count == 0:
		level_cleared.emit()
