extends Node2D



var simplearrow = preload("res://Entities/Hemwick/Bows/Arrows/SimpleArrow.png")
var firearrow = preload("res://Entities/Hemwick/Bows/Arrows/FireArrow.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	$ArrowSlot1/ArrowNumber.text = "%s" % [PlayerGlobal.slot1number]


	if PlayerGlobal.slot1number == 0:
		PlayerGlobal.slot1 = "none"
		PlayerGlobal.slot1_busy = false

	#SLOT 1 ---------------------------------------------------------------------------------
	if PlayerGlobal.slot1 == "none":
		$ArrowSlot1/ArrowNumber.visible = false
		$ArrowSlot1/Arrow1.visible = false
	else:
		$ArrowSlot1/Arrow1.visible = true
		$ArrowSlot1/ArrowNumber.visible = true


	if PlayerGlobal.slot1 == "simplearrow":
		$ArrowSlot1/Arrow1.texture = simplearrow
	elif PlayerGlobal.slot1 == "firearrow":
		$ArrowSlot1/Arrow1.texture = firearrow














