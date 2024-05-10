extends PanelContainer

class_name PermUpgrade

@export var Name : String = ""
@export var GlobalVariable : String = ""
@export var BaseCost : int = 10

@onready var Level1 = $Container/Level1
@onready var Level2 = $Container/Level2
@onready var Level3 = $Container/Level3
@onready var Level4 = $Container/Level4
@onready var Level5 = $Container/Level5
@onready var NameNode = $Container/Name
@onready var StatusNode = $Container/Status
@onready var BuyButton = $Container/Cost

var cost = BaseCost

func _ready() -> void:
	update()
	EventBus.upgrade_tokens_updated.connect(_on_upgrade_tokens_updated)


func update() -> void:
	cost = BaseCost
	var qty = Global.get(GlobalVariable)
	
	var inactive : Color = Color.DARK_SLATE_GRAY
	
	
	if qty < 1:
		Level1.modulate = inactive
	else:
		Level1.modulate = Color.ROYAL_BLUE
		cost *= 2
	if qty < 2:
		Level2.modulate = inactive
	else:
		cost *= 2
		Level2.modulate = Color.GREEN
	if qty < 3:
		Level3.modulate = inactive
	else:
		cost *= 2
		Level3.modulate = Color.RED
	if qty < 4:
		Level4.modulate = inactive
	else:
		cost *= 2
		Level4.modulate = Color.SILVER
	if qty < 5:
		Level5.modulate = inactive
	else:
		cost = -1
		Level5.modulate = Color.GOLD
		BuyButton.text = "MAX"

	NameNode.text = Name
	StatusNode.text = Global.call("format_" + GlobalVariable)
	if not cost == -1:
		BuyButton.text = "%d" % cost

	BuyButton.disabled = (Global.upgrade_tokens < cost) or (cost == -1)

func _on_cost_pressed() -> void:
	var now = Global.get(GlobalVariable)
	if now < 5:
		Global.set(GlobalVariable, now + 1)
		Global.upgrade_tokens -= cost
	pass # Replace with function body.

func _on_upgrade_tokens_updated(qty : int) -> void:
	update()
