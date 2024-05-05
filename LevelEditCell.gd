extends TextureRect

var type : String = " "

func _input(event : InputEvent) -> void:
	if event is InputEventKey:
		if get_rect().encloses(Rect2(get_viewport().get_mouse_position(),Vector2(1, 1))):
			if event.pressed:
				match event.keycode:
					KEY_R: 
						set_brick_type("R")
					KEY_Y: 
						set_brick_type("Y")
					KEY_G: 
						set_brick_type("G")
					KEY_B: 
						set_brick_type("B")
					KEY_M: 
						set_brick_type("M")
					KEY_C: 
						set_brick_type("C")
					KEY_O: 
						set_brick_type("O")
					KEY_W: 
						set_brick_type("W")
					KEY_1:
						set_brick_type("s")
					KEY_2:
						set_brick_type("g")
					KEY_3:
						set_brick_type("i")
					KEY_DELETE, KEY_BACKSPACE, KEY_SPACE:
						set_brick_type(" ")

func set_brick_type(t : String) -> void:
	match t:
		"R": 
			texture = load("res://Brick/BaseBrick.png")
			modulate = Color.RED
			type = "R"
		"Y": 
			texture = load("res://Brick/BaseBrick.png")
			modulate = Color.YELLOW
			type = "Y"
		"G": 
			texture = load("res://Brick/BaseBrick.png")
			modulate = Color.GREEN
			type = "G"
		"B": 
			texture = load("res://Brick/BaseBrick.png")
			modulate = Color.ROYAL_BLUE
			type = "B"
		"M": 
			texture = load("res://Brick/BaseBrick.png")
			modulate = Color.MAGENTA
			type = "M"
		"C": 
			texture = load("res://Brick/BaseBrick.png")
			modulate = Color.CYAN
			type = "C"
		"O": 
			texture = load("res://Brick/BaseBrick.png")
			modulate = Color.ORANGE
			type = "O"
		"W": 
			texture = load("res://Brick/BaseBrick.png")
			modulate = Color.WHITE
			type = "W"
		"s":
			texture = load("res://Brick/ShinyBrick.png")
			modulate = Color.SILVER
			type = "s"
		"g":
			texture = load("res://Brick/ShinyBrick.png")
			modulate = Color.GOLD
			type = "g"
		"i":
			texture = load("res://Brick/InvulBrick.png")
			modulate = Color.GRAY
			type = "i"						
		" ":
			texture = load("res://Brick/BlankBrick.png")
			modulate = Color.WHITE
			type = " "
